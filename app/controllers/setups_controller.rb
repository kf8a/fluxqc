class SetupsController < ApplicationController
  def new
    @templates = Template.all
    @template = Run.new
  end
end
