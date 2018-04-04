# frozen_string_literal: true

class StandardCurvesController < ApplicationController
  def show
    standard_curve = StandardCurve.find(params[:id])
    # include_methods = %w[data ymax ymin multiplier fit_line slope]
    include_methods = %w[data ymax ymin fit_line slope]
    render json: standard_curve.as_json(methods: include_methods)
  end

  def update
    standard_curve = StandardCurve.find(params[:id])
    if standard_curve.run.published?
      head :forbidden
    else
      standard_curve.data = params[:data]
      standard_curve.save
      # run = standard_curve.run
      # CalibrateJob.perform_later run
      head :ok
    end
  end
end
