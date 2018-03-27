# frozen_string_literal: true

class IncubationsController < ApplicationController
  before_action :check_company, except: [:show]

  respond_to :html, :json

  def show
    @incubation = Incubation.find(params[:id])
    respond_with do |format|
      format.html
      format.json { render json: @incubation }
    end
  end

  def edit
    @incubation = Incubation.find(params[:id])
  end

  def update
    incubation = Incubation.find(params[:id])

    unless incubation.run.published?
      if incubation.update_attributes(incubation_params)
        incubation.recompute_fluxes
        incubation.run.touch
        flash[:notice] = 'Incubation was successfully updated'
      end
    end

    redirect_to edit_run_path(incubation.run)
  end

  private

  def incubation_params
    params.require(:incubation).permit(:id, :treatment, :replicate, :chamber,
                                       :lid_id, { sampled_at: [] },
                                       :avg_height_cm,
                                       :soil_temperature,
                                       samples_attributes: %i[id seconds])
  end

  def check_company
    return unless params[:id]
    incubation = Incubation.find(params[:id])
    render status: :forbidden if current_user.company != incubation.run.company
  end
end
