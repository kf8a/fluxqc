class StandardCurvesController < ApplicationController

  def show
    standard_curve = StandardCurve.find(params[:id])
    render :json => standard_curve.as_json(:methods=>['data','ymax','ymin',
           'multiplier','fit_line','slope'])
  end

  def update
    standard_curve = StandardCurve.find(params[:id])
    standard_curve.data = params[:data]
    standard_curve.save

    #TODO: update the measurements of the run and recompute fluxes
    render :nothing => true
  end
end
