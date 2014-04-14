class IncubationsController < ApplicationController

  before_filter :check_company, except: [:show]

  respond_to :html, :json

  def show
    @incubation = Incubation.find(params[:id])
    respond_with do |format|
      format.html
      format.json {render :json  => @incubation}
    end
  end

  def edit
    @incubation = Incubation.find(params[:id])
  end

  def update
    incubation = Incubation.find(params[:id])

    unless incubation.run.published?
      if incubation.update_attributes(params[:incubation])
        flash[:notice] = 'Incubation was successfully updated'
      end
    end

    redirect_to run_path(incubation.run)
  end

  private

  def check_company
    if params[:id]
      incubation = Incubation.find(params[:id])
      if current_user.company != incubation.run.company
        render status: :forbidden
      end
    end
  end
end
