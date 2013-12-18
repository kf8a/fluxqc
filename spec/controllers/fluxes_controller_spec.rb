require 'spec_helper'

describe FluxesController do

  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe 'GET show' do

    pending 'test the show action'
  end

  describe 'PUT update point' do
    before do
      @flux         = FactoryGirl.create :flux
      @measurement  = FactoryGirl.create :measurement, :flux_id => @flux.id
    end

      it 'is successful' do
        @flux.stub(:save).and_return(true)
        Flux.any_instance.stub(:headspace).and_return(1.2)
        Flux.any_instance.stub(:surface_area).and_return(4.5)
        Flux.any_instance.stub(:mol_weight).and_return(12.3)
        post :update, id: @flux.id , data: [{id: @measurement.id, key: 40, value: 1.69, area: 33.34, deleted: true}]
        response.code.should == "200"
      end
  end

end
