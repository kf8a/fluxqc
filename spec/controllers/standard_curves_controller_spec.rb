require 'rails_helper'

describe StandardCurvesController, type: :controller do

  describe 'an authenticated user' do
    before do 
      @user = FactoryGirl.create(:user)
      @curve = FactoryGirl.create(:standard_curve)
      sign_in @user
    end

    describe "GET 'show'" do
      it "returns http success" do
        get 'show', :id => @curve
        expect(response).to be_success
      end
    end

    describe "GET 'update'" do
      it "returns http success" do
        allow_any_instance_of(StandardCurve).to receive(:run).and_return(Run.new)
        get 'update', :id => @curve, :data =>{}
        expect(response).to be_success
      end
    end

  end
end
