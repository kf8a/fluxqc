# Class to handle the uploading of a setup file under resque
# Resque requires that it have a perform method
class DataFileLoader
  @queue = :data_queue

  STANDARDS = {
    'STD0'  => {'n2o' => 0.000, 'co2' =>   0.000,  'ch4' => 0.000},
    'STD00'  => {'n2o' => 0.000, 'co2' =>   0.000,  'ch4' => 0.000},
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
    vials = DataParser.new.parse(file_path)

    dataloader.process_vials(vials)

    #connect standards
    run.attach_standards_to_samples
    #compute fluxes
    run.recompute_fluxes
  end

  def process_vials(vials)
    get_new_standard_curves = true
    standard_curves = {}

    vials.each do |vial|
      if vial[:vial] =~ /(CKH|STD|check|)?.*[a-z]$/i
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
    result['n2o'] = {
      0 => StandardCurve.create(run_id: @run.id, compound_id: compound.id, column: 0),
      1 => StandardCurve.create(run_id: @run.id, compound_id: compound.id, column: 1)
    }
    ['co2','ch4'].each do |name|
      compound = Compound.find_by(name: name)
      result[name] = {
        0 => StandardCurve.create(run_id: @run.id, compound_id: compound.id, column: 0),
      }
    end
    result
  end

	def process_sample(vial)
		sample = @run.samples.where(:vial => vial[:vial]).first
		if sample
			['co2','n2o','ch4'].each do |c|
				measurement = sample.measurements.by_compound(c).first

				value = vial[c.to_sym]

				measurement.column      = value[:column]
				measurement.acquired_at = vial[:acquired_at]
				measurement.ppm         = value[:ppm]
				measurement.area        = value[:area]

				measurement.save
			end
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

		['co2','n2o','ch4'].each do |c|
			value = vial[c.to_sym]
			compound = Compound.find_by_name(c)
      column = 0
      column = value[:column] if c == 'n2o'
      standard_curve = standard_curves[c][column]
      standard_curve.sampled_at = vial[:acquired_at]
      standard_curve.save

			standard = Standard.create(:vial         => vial[:vial], 
																 :compound_id  => compound.id, 
																 :acquired_at  => vial[:acquired_at],
																 :column       => value[:column],
																 :area         => value[:area], 
																 :ppm          => value[:ppm])
			standard_curve.standards << standard

			if standard.area == standard.ppm  || standard.ppm.nil? # we don't have ppm's in the file. Try to deduce it from the name
        # check to see if the standard starts with the string STD
        # TODO remove after we are done with the current runs
        if !(standard.vial =~ /STD/)
          standard.vial = "STD" + standard.vial
        end
				standard_values = STANDARDS[standard.vial.chop]

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

	def find_or_create_standard_curve(compound)
		standard_curve = StandardCurve.find_by_run_id_and_compound_id(@run,compound)
		unless standard_curve
			standard_curve = StandardCurve.create(:run=>@run, :compound=>compound)
			@run.standard_curves << standard_curve
			standard_curve.save
		end
		standard_curve
	end


  def process_checks(check_vials)

  end
end
