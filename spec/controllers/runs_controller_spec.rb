require 'spec_helper'

describe RunsController do
 include Devise::TestHelpers 

  before(:each) do
    @user = Factory.create(:user)
    sign_in @user
  end

  describe "GET 'index'" do
    it "returns http success" do
      get :index
      response.should be_success
    end
    it 'renders the index template' do
      get :index
      response.should render_template(:index)
    end
  end

  describe "GET 'show'" do
    before(:all) do
      @run = Factory.create :run
    end
    it "returns http success" do
      get :show, :id => @run
      response.should be_success
    end
    it 'renders the show template' do
      get :show, :id => @run
      response.should render_template(:show)
    end
  end

end
