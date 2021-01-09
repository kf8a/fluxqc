# frozen_string_literal: true

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
    run.save
    if run.samples.size.positive? && run.data_files.empty?
      # run.samples.delete
      reload_results = true
    end
    factory = IncubationFactory.new(run_id)
    samples.each do |sample|
      run.incubations << factory.create(sample)
    end
    if reload_results
      # TODO: reload results here
    end
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
