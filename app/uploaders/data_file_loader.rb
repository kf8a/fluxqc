# Class to handle the uploading of a setup file under resque
# Resque requires that it have a perform method
class DataFileLoader
  @queue = :data_queue

  def self.perform(run_id)
    true
  end

end
