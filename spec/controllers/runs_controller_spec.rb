require 'spec_helper'

describe RunsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
    it 'renders the index template' do
      get 'index'
      response.should render_template(:index)
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      response.should be_success
    end
    it 'renders the show template' do
      get 'show'
      response.should render_template(:show)
    end
  end

end
