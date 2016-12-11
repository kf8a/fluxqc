# Root application controller
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :authenticate_user!, except: [:index]
end
