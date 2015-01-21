require 'rails_helper'

describe FluxesController, :type => :controller do

  before(:each) do
    @user = FactoryGirl.create(:user)
    allow(@user).to receive(:company).and_return("lter")
    sign_in @user
  end

  describe 'PUT update point' do
    before do
      @run          = FactoryGirl.create :run
      @flux         = FactoryGirl.create :flux
      @measurement  = FactoryGirl.create :measurement, flux_id: @flux.id

    end

    it 'is successful' do
      allow(@flux).to receive(:save).and_return(true)
      allow_any_instance_of(Measurement).to receive(:standard_curves).and_return(1)
      allow_any_instance_of(Flux).to receive(:run).and_return(@run)
      allow_any_instance_of(Flux).to receive(:company).and_return("lter")
      allow_any_instance_of(Flux).to receive(:headspace).and_return(1.2)
      allow_any_instance_of(Flux).to receive(:surface_area).and_return(4.5)
      allow_any_instance_of(Flux).to receive(:mol_weight).and_return(12.3)
      post :update, id: @flux.id , data: [{id: @measurement.id, key: 40, value: 1.69, area: 33.34, deleted: true}]
      expect(response.code).to eq "200"
    end
  end

end
