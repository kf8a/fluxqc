class MeasurementsController < ApplicationController
  before_filter :authenticate_user!

  def index
    render_csv
  end

  private

  def render_csv
    set_file_headers
    set_streaming_headers

    response.status = 200

    #setting the body to an enumerator, rails will iterate this enumerator
    self.response_body = csv_lines
  end

  def set_file_headers
    file_name = "measurements.csv"
    headers["Content-Type"] = "text/csv"
    headers["Content-disposition"] = "attachment; filename=\"#{file_name}\""
  end

  def set_streaming_headers
    #nginx doc: Setting this to "no" will allow unbuffered responses suitable for Comet and HTTP streaming applications
    headers['X-Accel-Buffering'] = 'no'

    headers["Cache-Control"] ||= "no-cache"
    headers.delete("Content-Length")
  end

  def csv_lines

    Enumerator.new do |y|
      y << Measurement.csv_header.to_s

      #ideally you'd validate the params, skipping here for brevity
      Measurement.find_in_batches(){ |measurement| y << measurement.to_csv_row.to_s }
    end

  end
end
