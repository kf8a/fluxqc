namespace :util do
  desc "move file attachments from data_file to data_files"
  task :to_multi_file => :environment do
    Run.where('data_files is null').each do |run|
      array = []
      array << run.data_file
      run.data_files = array
      # file = run.data_file.current_path
      # run.data_files = [File.open(file)]
      run.save
    end
  end
end
