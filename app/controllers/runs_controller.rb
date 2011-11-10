class RunsController < ApplicationController
  def index
    params[:state] ||= 'uploaded'
    @state = params[:state]
    @runs = Run.by_state(@state).order('sampled_on desc')
  end

  def show
  end

end
