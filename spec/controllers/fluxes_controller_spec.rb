require 'rails_helper'

describe FluxesController, :type => :controller do

  before(:each) do
    @user = FactoryGirl.create(:user)
    @user.stub(:company).and_return("lter")
    sign_in @user
  end

  describe 'PUT update point' do
    before do
      @run          = FactoryGirl.create :run
      @flux         = FactoryGirl.create :flux
      @measurement  = FactoryGirl.create :measurement, flux_id: @flux.id

    end

    it 'is successful' do
      @flux.stub(:save).and_return(true)
      Measurement.any_instance.stub(:standard_curves).and_return(1)
      Flux.any_instance.stub(:run).and_return(@run)
      Flux.any_instance.stub(:company).and_return("lter")
      Flux.any_instance.stub(:headspace).and_return(1.2)
      Flux.any_instance.stub(:surface_area).and_return(4.5)
      Flux.any_instance.stub(:mol_weight).and_return(12.3)
      post :update, id: @flux.id , data: [{id: @measurement.id, key: 40, value: 1.69, area: 33.34, deleted: true}]
      expect(response.code).to eq "200"
    end
  end

end
