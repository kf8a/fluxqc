class RunsController < ApplicationController
  def index
    @runs = Run.order('sampled_on desc')
  end

  def show
  end

end
