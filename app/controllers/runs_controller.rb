class RunsController < ApplicationController

  respond_to :html, :json, :csv

  def index
    params[:state] ||= 'uploaded'
    @state = params[:state]
    @runs = Run.by_state(@state).order('sampled_on desc')
  end

  def show
    @run = Run.find(params[:id])
    @incubations = @run.incubations
    respond_with do |format|
      format.html
      format.json {render :json  => @incubations.as_json(:methods=>['co2','n2o','ch4'])}
    end
  end

end
