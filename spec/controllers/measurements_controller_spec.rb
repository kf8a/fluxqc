require 'spec_helper'

describe MeasurementsController do

  describe "GET 'index' as an authenticated user" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

end