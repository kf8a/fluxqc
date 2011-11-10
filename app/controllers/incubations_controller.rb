class IncubationsController < ApplicationController

  respond_to :html, :json

  def index
    @incubations = Run.find(68).incubations
    respond_with do |format|
      format.html
      format.json {render :json  => @incubations.as_json(:methods=>['co2','n2o','ch4'])}
    end
  end

  def show
    @incubation = Incubation.find(params[:id])
    respond_with do |format|
      format.html
      format.json {render :json  => @incubation.as_json(:methods=>['co2','n2o','ch4'])}
    end
  end
end
