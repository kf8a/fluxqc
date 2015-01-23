class FluxesController < ApplicationController

  before_filter :authenticate_user!

  respond_to :html, :json

  def index
   render_csv(params[:study])
  end

  def show
    @flux = Flux.find(params[:id])
    respond_with do |format|
      format.html
      format.json {render :json => @flux.as_json(:methods=>['data','ymax','ymin',
                                                            'multiplier','fit_line','flux']) }
    end
  end

  def update
    flux = Flux.find(params[:id])
    unless flux.run.published?
      flux.data = params[:data]
      flux.save
      head :ok
    else
      head  :forbidden
      response.status :prohibited
    end

  end

  def render_csv(study)
    set_file_headers(study)
    set_streaming_headers

    response.status = 200

    #setting the body to an enumerator, rails will iterate this enumerator
    self.response_body = csv_lines(study)
  end

  def set_file_headers(study)
    file_name = "#{study}-fluxes.csv"
    headers["Content-Type"] = "text/csv"
    headers["Content-disposition"] = "attachment; filename=\"#{file_name}\""
  end

  def set_streaming_headers
    #nginx doc: Setting this to "no" will allow unbuffered responses suitable for Comet and HTTP streaming applications
    headers['X-Accel-Buffering'] = 'no'

    headers["Cache-Control"] ||= "no-cache"
    headers.delete("Content-Length")
  end

  def csv_lines(study)

    Enumerator.new do |y|
      y << Flux.csv_header.to_s

      #ideally you'd validate the params, skipping here for brevity
      Flux.find_in_batches(study){ |measurement| y << measurement.to_csv_row.to_s }
    end

  end

end
