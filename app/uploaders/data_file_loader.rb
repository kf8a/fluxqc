# Class to handle the uploading of a setup file under resque
# Resque requires that it have a perform method
class DataFileLoader
  @queue = :data_queue

  STANDARDS = {
    'STD0'  => {'n2o' => 0.000, 'co2' =>   0.000,  'ch4' => 0.000},
    'STD07' => {'n2o' => 0.294, 'co2' =>  350.423, 'ch4' => 0.565},
    'STD10' => {'n2o' => 0.420, 'co2' =>  500.605, 'ch4' => 0.806},
    'STD15' => {'n2o' => 0.629, 'co2' =>  750.907, 'ch4' => 1.210},
    'STD20' => {'n2o' => 0.839, 'co2' => 1001.201, 'ch4' => 1.613},
    'STD30' => {'n2o' => 1.259, 'co2' => 1501.815, 'ch4' => 2.419},
    'STD40' => {'n2o' => 1.678, 'co2' => 2002.419, 'ch4' => 3.226}
  }

  CHK = {'n2o' => 0.294, 'co2' => 350.423, 'ch4' => 0.565 }

  def initialize(run=nil)
    @run = run
  end
  def self.perform(run_id)
    run = Run.find(run_id)
    dataloader = DataFileLoader.new(run)

    file_path = run.data_file.file.path
    vials = DataParser.parse(file_path)

    standard_vials, sample_vials = vials.partition {|x| x[:vial] =~ /CHK|STD|check|.*[a-z]$/i }

    # standards, checks = standard_vials.partition {|x| x[;vial] =~ /STD*/i }

    dataloader.process_samples(sample_vials)

    dataloader.process_standard(standard_vials)

    # dataloger.process_checks(checks)
  end

  def process_samples(sample_vials)
    sample_vials.each do |vial|
      sample = @run.samples.where(:vial => vial[:vial]).first
      if sample
        ['co2','n2o','ch4'].each do |c|
          measurement = sample.measurements.by_compound(c).first

          value = vial[c.to_sym]

          measurement.ppm   = value[:ppm]
          measurement.area  = value[:area]

          measurement.save
        end
      end
    end
  end

  def process_standard(standard_vials)
    standard_vials.each do |vial|
      # find or create a standard for the compound
      # create and add the measurement
      ['co2','n2o','ch4'].each do |c|
        value = vial[c.to_sym]
        compound = Compound.find_by_name(c)
        standard_curve = StandardCurve.find_by_run_id_and_compound_id(@run,compound)

        unless standard_curve
          standard_curve = StandardCurve.create(:run=>@run, :compound=>compound)
          @run.standard_curves << standard_curve
          standard_curve.save
        end

        standard = Standard.create(:vial=> vial[:vial], :compound_id => compound.id, :area => value[:area], :ppm => value[:ppm])
        standard_curve.standards << standard

        if standard.area == standard.ppm  || standard.ppm.nil? # we don't have ppm's in the file. Try to deduce it from the name
          standard_values = STANDARDS[standard.vial.chop]
          if standard_values
            standard.ppm = standard_values[c]
          else 
            # we propably have a check standard ie air
            standard.ppm = CHK[c]
          end
        end
        standard.save
      end
    end
  end

  def process_checks(check_vials)

  end
end
