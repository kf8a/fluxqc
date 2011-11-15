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

  def new
    @run = Run.new
  end

  def reject
    run = Run.find(params[:id])
    run.reject!
    redirect_to runs_path
  end

  def accept
    run = Run.find(params[:id])
    run.accept!
    redirect_to runs_path
  end
  
  def approve
    run = Run.find(params[:id])
    run.approve!
    redirect_to runs_path
  end

  def publish
    run = Run.find(params[:id])
    run.publish!
    redirect_to runs_path
  end
  def unapprove
    run = Run.find(params[:id])
    run.unapprove!
    redirect_to runs_path
  end

  def unpublish
    run = Run.find(params[:id])
    run.unpublish!
    redirect_to runs_path
  end

end
