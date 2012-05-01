class RunsController < ApplicationController

  respond_to :html, :json, :csv

  def index
    params[:state] ||= 'uploaded'
    @state = params[:state]
    @runs = Run.by_state(@state).order('sampled_on desc')
  end

  def show
    @run = Run.find(params[:id])
    @state = @run.current_state.name.to_s

    @incubations = @run.incubations
    respond_with do |format|
      format.html { render  :layout=> 'qc'}
      format.json {render :json  => @incubations.as_json(:methods=>['co2','n2o','ch4'])}
    end
  end

  def new
    @run = Run.new
  end

  def create
    @run = Run.new(params[:run])
    if @run.save
      if params[:run][:setup_file]
        # if Rails.env == 'production'
        #   Resque.enqueue(SetupFileLoader, @run.id)
        # else
        SetupFileLoader.perform(@run.id)
        # end
      end
      if params[:run][:data_file]
        # if Rails.env == 'production'
        #   Resque.enqueue(DataFileLoader, @run.id)
        # else
        DataFileLoader.perform(@run.id)
        # end
      end
      redirect_to edit_run_path(@run)
    else
      redirect_to new_run_path
    end
  end

  def edit
    @run = Run.find(params[:id])
    @state = @run.current_state.name.to_s
    respond_with do |format|
      format.html { render  :layout=> 'qc'}
    end
  end

  def update
    @run = Run.find(params[:id])
    if @run.update_attributes(params[:run])
      if params[:run][:setup_file]
        # if Rails.env == 'production'
        #   Resque.enqueue(SetupFileLoader, @run.id)
        # else
        SetupFileLoader.perform(@run.id)
        # end
      end
      if params[:run][:data_file]
        # if Rails.env == 'production'
        #   Resque.enqueue(DataFileLoader, @run.id)
        # else
        DataFileLoader.perform(@run.id)
        # end
      end
      redirect_to run_path(@run)
    else
      redirect_to edit_run_path(@run)
    end
  end

  def gcinput
    @run = Run.find(params[:id])
  end

  def reject
    run = Run.find(params[:id])
    run.reject!
    redirect_to runs_path(:state=>'rejected')
  end

  def standards
    run = Run.find(params[:id])
  end

  def accept
    run = Run.find(params[:id])
    run.accept!
    redirect_to runs_path(:state=>'accepted')
  end

  def approve
    run = Run.find(params[:id])
    run.approve!
    redirect_to runs_path(:state=>'approved')
  end

  def publish
    run = Run.find(params[:id])
    run.publish!
    redirect_to runs_path(:state=>'published')
  end

  def unapprove
    run = Run.find(params[:id])
    run.unapprove!
    redirect_to runs_path(:state =>'accepted')
  end

  def unpublish
    run = Run.find(params[:id])
    run.unpublish!
    redirect_to runs_path(:state => 'approved')
  end

  def unreject
    run = Run.find(params[:id])
    run.unreject!
    redirect_to runs_path(:state=>'uploaded')
  end

  def destroy
    Run.destroy(params[:id])
    redirect_to runs_path(:state => 'uploaded')
  end

end
