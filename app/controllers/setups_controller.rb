class SetupsController < ApplicationController
  def new
    @template = Run.new
  end
end
