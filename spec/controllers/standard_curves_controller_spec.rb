require 'spec_helper'

describe StandardCurvesController do

  describe 'an authenticated user' do
    before do 
      @user = FactoryGirl.create(:user)
      @curve = FactoryGirl.create(:standard_curve)
      sign_in @user
    end

    describe "GET 'show'" do
      it "returns http success" do
        get 'show', :id => @curve
        response.should be_success
      end
    end

    describe "GET 'update'" do
      it "returns http success" do
        get 'update', :id => @curve, :data =>[]
        response.should be_success
      end
    end

  end
end
