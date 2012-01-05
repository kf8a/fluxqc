require File.expand_path("../../../lib/setup_parser.rb",__FILE__)
require File.expand_path("../../../lib/incubation_factory.rb",__FILE__)

# Class the handle the uploading of a setup file under resque
# Resque requires that it have a perform method
class SetupFileLoader
  @queue = :setup_queue

  def self.perform(run_id)
    run = Run.find(run_id)
    file_path = run.setup_file.file.path
    samples = SetupParser.parse(file_path)
    run.sampled_on = samples[0][:sample_date].try(:to_date)
    samples.each do |sample|
      run.incubations << IncubationFactory.create(run.id, sample)
    end
    run.save
  end

end
