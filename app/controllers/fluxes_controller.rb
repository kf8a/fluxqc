class FluxesController < ApplicationController
  before_filter :check_company, except: [:show]

  respond_to :html, :json

  def show
    @flux = Flux.find(params[:id])
    respond_with do |format|
      format.html
      format.json {render :json => @flux.as_json(:methods=>['data','ymax','ymin',
                                                            'multiplier','fit_line','flux']) }
    end
  end

  def update
    flux = Flux.find(params[:id])
    flux.data = params[:data]
    flux.save

    render :nothing => true
  end

  private
  def check_company
    if params[:id]
      flux = Flux.find(params[:id])
      p current_user.company
      if current_user.company != flux.company
        head status: :forbidden
      end
    end
  end
end
