# Class to handle the uploading of a setup file under resque
# Resque requires that it have a perform method
class DataFileLoader
  @queue = :data_queue

  def self.perform(run_id)
    run = Run.find(run_id)
    file_path = run.data_file.file.path
    vials = DataParser.parse(file_path)

    vials.each do |vial|
      sample = run.samples.where(:vial => vial[:vial]).first
      if sample
        ['co2','n2o','ch4'].each do |c|
          measurement = sample.measurements.by_compound(c).first
          value = vial[c.to_sym]
          measurement.ppm = value[:ppm]
          measurement.area = value[:area]
          measurement.save
        end
      end
    end
  end

end
