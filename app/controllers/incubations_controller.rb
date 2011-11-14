class IncubationsController < ApplicationController

  respond_to :html, :json

  def show
    @incubation = Incubation.find(params[:id])
    respond_with do |format|
      format.html
      format.json #{render :json  => @incubation.as_json(:methods=>['co2','n2o','ch4'])}
    end
  end

  def edit
    @incubation = Incubation.find(params[:id])
  end

  def update
    incubation = Incubation.find(params[:id])
    
    if incubation.update_attributes(params[:incubation])
      flash[:notice] = 'Incubation was successfully updated'
    end

    redirect_to run_path(incubation.run)
  end
end
