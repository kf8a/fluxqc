# Class the handle the uploading of a setup file under resque
# Resque requires that it have a perform method
class SetupFileLoader
  @queue = :setup_queue

  def self.perform(run_id)
    run = Run.find(run_id)
    true
  end

end
