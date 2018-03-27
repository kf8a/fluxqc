# frozen_string_literal: true

class FluxesController < ApplicationController
  before_action :authenticate_user!

  respond_to :html, :json

  def index
    render_csv(params[:study])
  end

  def show
    @flux = Flux.find(params[:id])
    respond_with do |format|
      format.html
      include_methods = %w[data ymax ymin multiplier fit_line flux]
      format.json { render json: @flux.as_json(methods: include_methods) }
    end
  end

  def update
    flux = Flux.find(params[:id])
    if flux.run.published?
      head :forbidden
    else
      flux.data = params[:data]
      flux.save
      head :ok
    end
  end

  def render_csv(study)
    file_headers(study)
    streaming_headers

    response.status = 200

    # setting the body to an enumerator, rails will iterate this enumerator
    self.response_body = csv_lines(study)
  end

  def file_headers(study)
    file_name = "#{study}-fluxes.csv"
    headers['Content-Type'] = 'text/csv'
    headers['Content-disposition'] = "attachment; filename=\"#{file_name}\""
  end

  def streaming_headers
    # nginx doc: Setting this to "no" will allow unbuffered responses
    # suitable for Comet and HTTP streaming applications
    headers['X-Accel-Buffering'] = 'no'

    headers['Cache-Control'] ||= 'no-cache'
    headers.delete('Content-Length')
  end

  def csv_lines(study)
    Enumerator.new do |y|
      y << Flux.csv_header.to_s

      # ideally you'd validate the params, skipping here for brevity
      Flux.find_in_batches(study) do |measurement|
        y << measurement.to_csv_row.to_s
      end
    end
  end
end
