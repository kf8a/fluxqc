class FluxesController < ApplicationController
  respond_to :html, :json

  def show
    @flux = Flux.find(params[:id])
    respond_with do |format|
      format.html
      format.json {render :json => @flux.as_json(:methods=>['data','ymax','ymin','multiplier','fit_line','flux']) }
    end
  end

  def update
    render :nothing => true
  end
end
