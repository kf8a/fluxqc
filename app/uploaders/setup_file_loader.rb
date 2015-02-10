require File.expand_path("../../../lib/setup_parser.rb",__FILE__)
require File.expand_path("../../../lib/incubation_factory.rb",__FILE__)

# Class the handle the uploading of a setup file under resque
# Resque requires that it have a perform method
class SetupFileLoader
  @queue = :setup_queue

  def self.perform(run_id)
    run = Run.find(run_id)
    file_path = run.setup_file.file.path
    samples = SetupParser.parse(file_path).compact
    run.sampled_on = samples[0][:sample_date].try(:to_date)
    run.name = samples[0][:run_name]
    run.study = get_study_name(run.name)
    reload_results = false
    if run.samples.size > 0
      #run.samples.delete
      if run.result_files.size > 0
        reload_results = true
      end
    end
    samples.each do |sample|
      run.incubations << IncubationFactory.create(run.id, sample)
    end
    if reload_results
      #TODO reload results here
    end
    run.save
  end

  def self.get_study_name(name)
    if name.start_with?('LTER')
      'lter'
    elsif name.start_with?('GLBRC')
      'glbrc'
    elsif name.start_with?('CIMMYT')
      'cimmyt'
    end
  end
end
