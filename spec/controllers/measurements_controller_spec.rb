require 'rails_helper'

describe MeasurementsController, type: :controller do

  describe "GET 'index' as an authenticated user" do
    before(:each) do
      @user = FactoryBot.create(:user)
      sign_in @user
    end
    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end
  end

end
