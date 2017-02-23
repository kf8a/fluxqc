class CalibrateJob < ActiveJob::Base
  queue_as :default

  def perform(run)
    c = Calibrate.new(run)
    c.calibrate!
  end
end
