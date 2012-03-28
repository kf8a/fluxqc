# Class to handle the uploading of a setup file under resque
# Resque requires that it have a perform method
class DataFileLoader
  @queue = :data_queue

  def self.perform(run_id)
    run = Run.find(run_id)
    file_path = run.data_file.file.path
    samples = DataParser.parse(file_path)
    
    samples.each do |s|
      p s
      sample = run.samples.where(:vial => s[:vial]).first
      p sample
      if sample
        ['co2','n2o','ch4'].each do |c|
          measurement = sample.measurements.by_compound(c).first
          measurement.ppm = s[c.to_sym]
          measurement.save
        end
      else
      end
    end
  end

end
