# Class to handle the uploading of a setup file under resque
# Resque requires that it have a perform method
class DataFileLoader
  @queue = :data_queue

  def initialize(run=nil)
    @run = run
  end
  def self.perform(run_id)
    run = Run.find(run_id)
    dataloader = DataFileLoader.new(run)

    file_path = run.data_file.file.path
    vials = DataParser.parse(file_path)

    standard_vials, sample_vials = vials.partition {|x| x[:vial] =~ /CHK|STD|check|.*[a-z]$/i }

    dataloader.process_samples(sample_vials)

    dataloader.process_standard(standard_vials)

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
        standard = Standard.find_by_run_id_and_compound_id(@run,compound)

        unless standard
          standard = Standard.create(:run=>@run, :compound=>compound)
          @run.standards << standard
          standard.save
        end

        measurement = Measurement.create(:vial=> vial[:vial], :compound_id => compound.id, :area => value[:area], :ppm => value[:ppm])
        standard.measurements << measurement

        if measurement.area == measurement.ppm  # we don't have ppm's in the file. Try to deduce it from the name
          case measurement.name
          when 'n23'
          end
        end
        measurement.save
      end
    end
  end
end
