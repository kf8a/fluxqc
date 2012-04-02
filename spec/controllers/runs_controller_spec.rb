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

  describe 'GET :new' do
    it 'returns http success' do
      get :new
      response.should be_success
    end

    it' renders the new template' do
      get :new
      response.should render_template(:new)
    end
  end

  describe ':POST create' do
    describe 'with a valid object' do 
     it 'redirects to show' do
       Run.any_instance.stub(:id).and_return(1)
       post :create , :run => {:name => 'test'}
       response.should redirect_to(edit_run_path(1))
     end
    end
    describe 'with an invalid object' do
      it 'redirects back to new' do
        Run.any_instance.stub(:save).and_return(false)
        post :create, {}
        response.should redirect_to(new_run_path)
      end
    end
  end

  describe 'GET :edit' do
    it 'is succesfull' do
      run = Factory.create :run
      get :edit, :id=>run
      response.should be_success
    end
  end

  describe 'PUT update' do 
    describe 'with a valid object' do
      it 'redirects to show' do
       Run.any_instance.stub(:save).and_return(true)
       Run.any_instance.stub(:id).and_return(1)
       post :update, :id=>1, :run=> {:name => 'test'}
       response.should redirect_to(run_path(assigns(:run)))
      end
    end
    describe 'with an invalid object' do
      it 'redirects back to new' do
        Run.any_instance.stub(:save).and_return(false)
        Run.any_instance.stub(:id).and_return(1)
        post :update, :id=>1 
        response.should redirect_to(edit_run_path(assigns(:run)))
      end
    end
  end

  describe 'computing the standards' do
    it 'computes the standard equation'
      # Run.any_instance.sub(:standardize).and_return(true)
      # Run.any_instance.stub(:id).and_return(1)
    it 'computes measurement ppms using the standard'
  end

  describe 'getting the sample table for the gc' do
    it 'delivers a sample table' do
      run = Factory.create :run
      get :gcinput, :id=>run, :format=>:csv
      response.should be_success
    end
  end

  describe 'a run workflow' do
    before(:each) do
      @run = Factory.create :run
      Run.stub(:find).and_return(@run)
    end

    describe 'POST reject' do
      it 'rejects a run' do
        @run.stub('reject!').and_return(true)
        post :reject, :id => @run
        response.should redirect_to(runs_path(:state=>'rejected'))
      end

    end

    describe 'POST accept' do
      it 'accepts a run' do
        @run.stub('accept!')
        post :accept, :id => @run
        response.should redirect_to(runs_path(:state=>'accepted'))
      end
    end

    describe 'POST approve' do
      it 'approves a run' do
        @run.stub('approve!')
        post :approve, :id => @run
        response.should redirect_to(runs_path(:state=>'approved'))
      end
    end

    describe 'POST publish' do
      it 'publishes a run' do
        @run.stub('publish!')
        post :publish, :id => @run
        response.should redirect_to(runs_path(:state => 'published'))
      end
    end

    describe 'POST unapprove' do
      it 'unapproves a run' do
        @run.stub('unapprove!')
        post :unapprove, :id => @run
        response.should redirect_to(runs_path(:state => 'accepted'))
      end
    end

    describe 'POST unpublish' do
      it 'unpublishes a run' do
        @run.stub('unpublish!').and_return(true)
        post :unpublish, :id=>@run
        response.should redirect_to(runs_path(:state => 'approved'))
      end
    end
  end

end
