class RunsController < ApplicationController

  respond_to :html, :json, :csv

  def index
    params[:state] ||= 'uploaded'
    @state = params[:state]
    @runs = Run.by_state(@state).order('sampled_on desc')
  end

  def all
    @runs = Run.where('company_id != 2').order('study').order('sampled_on desc')
    render :index
  end

  def show
    @run = run
    @state = @run.current_state.name.to_s

    @incubations = @run.incubations
    @standard_curves = @run.standard_curves.order('created_at')
    respond_with do |format|
      format.html { render  :layout=> 'qc'}
      format.json {render :json  => @incubations}
    end
  end

  def new
    @run = Run.new
  end

  def create
    @run = Run.new(run_params)
    @run.company = current_user.company
    if @run.save
      if params[:run][:setup_file]
        # if Rails.env == 'production'
        #   Resque.enqueue(SetupFileLoader, @run.id)
        # else
        SetupFileLoader.perform(@run.id)
        # end
      end
      if params[:run][:data_files]
        # if Rails.env == 'production'
        #   Resque.enqueue(DataFileLoader, @run.id)
        # else
        DataFileLoader.perform(@run.id)
        # end
      end
      if params[:run][:setup_file] && params[:run][:data_files]
        redirect_to run_path(@run)
      else
        redirect_to edit_run_path(@run)
      end
    else
      redirect_to new_run_path
    end
  end

  def edit
    @run = Run.includes(samples: [{incubation: :lid}, {measurements: :compound}]).find(params[:id])
    @state = @run.current_state.name.to_s
    respond_with do |format|
      format.html { render  :layout=> 'qc'}
    end
  end

  def update
    @run = run
    if @run.update_attributes(run_params)
      if params[:run][:setup_file]
        # if Rails.env == 'production'
        #   Resque.enqueue(SetupFileLoader, @run.id)
        # else
        SetupFileLoader.perform(@run.id)
        # end
      end
      if params[:run][:data_files]
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
    @run = run
  end

  def updated_at
    render text: run.updated_at
  end

  def reject
    run.reject!
    redirect_to runs_path(:state=>'rejected')
  end

  def standard_curves
    render nothing: true
    # run = Run.find(params[:id])

    # respond_with do |format| 
    #   format.json {render :json => 
    #     run.standard_curves.to_json(:methods => 
    #                                 ['data','ymax','ymin','multiplier',
    #                                   'fit_line','slope'])}
    # end
  end

  def accept
    run.accept!
    redirect_to runs_path(:state=>'uploaded')
  end

  def approve
    run.approve!
    redirect_to runs_path(:state=>'accepted')
  end

  def publish
    run.publish!
    redirect_to runs_path(:state=>'approved')
  end

  def unapprove
    run.unapprove!
    redirect_to runs_path(:state =>'approved')
  end

  def unpublish
    run.unpublish!
    redirect_to runs_path(:state => 'published')
  end

  def unreject
    run.unreject!
    redirect_to runs_path(:state=>'rejected')
  end

  def destroy
    Run.destroy(params[:id])
    redirect_to runs_path(:state => 'uploaded')
  end

  def park
    run.park!
    redirect_to runs_path(:state => 'uploaded')
  end

  private 

  def run
    Run.find(params[:id])
  end

  def run_params
    params.require(:run).permit!
    # (:name, :sampled_on, :run_on, :comment, :study, :setup_file, :data_file, incubations_attributes: [{:samples_attributes}], :setup_file_cache, :data_file_cache)
  end

end
