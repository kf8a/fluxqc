class StandardCurvesController < ApplicationController
  def show
    standard_curve = StandardCurve.find(params[:id])
    render json: standard_curve.as_json(methods:
                                        %w(dataymax ymin multiplier
                                           fit_line slope))
  end

  def update
    standard_curve = StandardCurve.find(params[:id])
    unless standard_curve.run.published?
      standard_curve.data = params[:data]
      standard_curve.save
      run = standard_curve.run
      CalibrateJob.perform_later run
      head :ok
    else
      head :forbidden
    end
  end
end
