# frozen_string_literal: true

# Class to handle the uploading of a setup file under resque
# Resque requires that it have a perform method
class DataFileLoader
  @queue = :data_queue

  # TODO: this needs to be in the tank table
  STANDARDS = { 'STD0'  => { 'n2o' => 0.000, 'co2' =>   0.000,  'ch4' => 0.000 },
                'STD00' => { 'n2o' => 0.000, 'co2' =>   0.000,  'ch4' => 0.000 },
                'STD07' => { 'n2o' => 0.294, 'co2' =>  350.423, 'ch4' => 0.565 },
                'STD10' => { 'n2o' => 0.420, 'co2' =>  500.605, 'ch4' => 0.806 },
                'STD15' => { 'n2o' => 0.629, 'co2' =>  750.907, 'ch4' => 1.210 },
                'STD20' => { 'n2o' => 0.839, 'co2' => 1001.201, 'ch4' => 1.613 },
                'STD30' => { 'n2o' => 1.259, 'co2' => 1501.815, 'ch4' => 2.419 },
                'STD40' => { 'n2o' => 1.678, 'co2' => 2002.419, 'ch4' => 3.226 } }.freeze

  # n2o    co2     ch4
  # 0.275  351.406 0.551 STD07
  # 0.393  502.008 0.787 STD10
  # 0.589  753.012 1.181 STD15
  # 0.785 1004.016 1.574 STD20
  # 1.178 1506.024 2.361 STD30
  # 1.570 2008.032 3.149 STD40

  CHK = { 'n2o' => 0.294, 'co2' => 350.423, 'ch4' => 0.565 }.freeze

  COMPOUNDS = %w[co2 n2o ch4].freeze

  def initialize(run = nil)
    @run = run
  end

  def self.perform(run_id)
    run = Run.find(run_id)
    dataloader = DataFileLoader.new(run)

    vials = run.data_files.collect do |data_file|
      DataParser.new.parse(data_file.current_path)
    end.flatten

    dataloader.process_vials(vials)

    # calibrate and compute fluxes
    c = Calibrate.new(run)
    c.calibrate!
    # compute fluxes
    # run.recompute_fluxes
  end

  def process_vials(vials)
    get_new_standard_curves = true
    standard_curves = {}

    vials.each do |vial|
      # Filter out samples with the name BLANK since they are used to
      # just adjust the number of vials to fit a standard try
      next if vial[:vial] =~ /BLANK/i

      if vial[:vial].match?(/(CHK|CKH|STD|check|)?.*[a-z]$/i)
        if get_new_standard_curves
          get_new_standard_curves = false
          standard_curves = new_standard_curves
        end
        process_standard(vial, standard_curves)
      else
        get_new_standard_curves = true
        process_sample(vial)
      end
    end
  end

  def process_samples(sample_vials)
    sample_vials.each do |vial|
      process_sample(vial)
    end
  end

  def new_standard_curves
    result = {}
    compound = Compound.find_by(name: 'n2o')
    result['n2o'] = new_n2o_standard_curves(compound)
    %w[co2 ch4].each do |name|
      compound = Compound.find_by(name: name)
      result[name] = { 0 => new_standard_curve_record(compound) }
    end
    result
  end

  def new_n2o_standard_curves(compound)
    {
      0 => new_standard_curve_record(compound, 0),
      1 => new_standard_curve_record(compound, 1)
    }
  end

  def new_standard_curve_record(compound, column = 0)
    StandardCurve.create(run_id: @run.id, compound_id: compound.id, column: column)
  end

  def process_sample(vial)
    sample = @run.samples.where(vial: vial[:vial]).first
    return unless sample

    COMPOUNDS.each do |c|
      measurement = sample.measurements.by_compound(c).first

      value = vial[c.to_sym]
      next unless value

      measurement.column = if c == 'n2o'
                             value[:column]
                           else
                             0
                           end
      measurement.acquired_at = vial[:acquired_at]
      measurement.ppm         = value[:ppm]
      measurement.area        = value[:area]

      measurement.save
    end
  end

  def process_standards(standard_vials)
    # checks, standard_vials = std_vials.partition {|x| x[:vial] =~ /CHK|check/i}
    standard_curves = new_standard_curves
    standard_vials.each do |vial|
      process_standard(vial, standard_curves)
    end
  end

  def process_standard(vial, standard_curves)
    # find or create a standard for the compound
    # create and add the measurement

    COMPOUNDS.each do |c|
      value = vial[c.to_sym]
      next unless value

      compound = Compound.find_by_name(c)

      column = value[:column]
      standard_curve = standard_curves[c][column]
      standard_curve.acquired_at = vial[:acquired_at]
      standard_curve.save

      standard = Standard.create(vial: vial[:vial],
                                 compound_id: compound.id,
                                 acquired_at: vial[:acquired_at],
                                 column: column,
                                 area: value[:area],
                                 excluded: exclude_standard?(compound, value[:ppm]),
                                 ppm: value[:ppm])
      standard_curve.standards << standard

      # we don't have ppm's in the file. Try to deduce it from the name
      standard_names = STANDARDS.keys
      if standard.area == standard.ppm || standard.ppm.nil?
        key = standard_names.select { |name| standard.vial.chop.match(name) }.first
        standard_values = STANDARDS[key]

        if standard_values
          standard.ppm = standard_values.fetch(c)
        else
          # we propably have a check standard or failed to look up a standard.
          standard.ppm = CHK[c]
          standard.excluded = true
        end
      end
      standard.save
    end
  end

  def exclude_standard?(compound, ppm)
    ppm == 0 && (compound.name == 'co2' || compound.name == 'ch4')
  end

  def find_or_create_standard_curve(compound)
    standard_curve = StandardCurve.find_by_run_id_and_compound_id(@run, compound)
    unless standard_curve
      standard_curve = StandardCurve.create(run: @run, compound: compound)
      @run.standard_curves << standard_curve
      standard_curve.save
    end
    standard_curve
  end

  def process_checks(check_vials); end
end
