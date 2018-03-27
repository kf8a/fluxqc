# frozen_string_literal: true

require 'rails_helper'

describe RunsController, type: :controller do
  before(:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET 'index'" do
    it 'returns http success' do
      get :index
      expect(response).to be_success
    end
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET 'show'" do
    before(:all) do
      @run = FactoryGirl.create :run
    end
    it 'returns http success' do
      get :show, id: @run
      expect(response).to be_success
    end
    it 'renders the show template' do
      get :show, id: @run
      expect(response).to render_template(:show)
    end
  end

  describe 'GET updated_at' do
    render_views

    before(:all) do
      @run = FactoryGirl.create :run
    end
    it 'returns http success' do
      get :updated_at, id: @run
      expect(response).to be_success
    end
    it 'returns the updated_at timestamp' do
      get :updated_at, id: @run
      expect(Time.parse(response.body)).to be_within(1).of(@run.updated_at)
    end
  end

  describe 'GET :new' do
    it 'returns http success' do
      get :new
      expect(response).to be_success
    end

    it' renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe ':POST create' do
    describe 'with a valid object' do
      it 'redirects to show' do
        allow_any_instance_of(Run).to receive(:id).and_return(1)
        post :create, run: { name: 'test' }
        expect(response).to redirect_to(edit_run_path(1))
      end
    end
    describe 'with an invalid object' do
      it 'redirects back to new' do
        allow_any_instance_of(Run).to receive(:save).and_return(false)
        post :create, run: { name: 'test' }
        expect(response).to redirect_to(new_run_path)
      end
    end
  end

  describe 'GET :edit' do
    it 'is succesfull' do
      run = FactoryGirl.create :run
      get :edit, id: run
      expect(response).to be_success
    end
  end

  describe 'PUT update' do
    describe 'with a valid object' do
      it 'redirects to show' do
        run = Run.create
        allow(Run).to receive(:find).with('1').and_return(run)
        post :update, id: 1, run: { name: 'test' }
        expect(response).to redirect_to(run_path(assigns(:run)))
      end
    end
    describe 'with an invalid object' do
      it 'redirects back to new' do
        run = Run.create
        allow(Run).to receive(:find).with('1').and_return(run)
        allow(run).to receive(:valid?).and_return(false)
        post :update, id: 1, run: { name: 'test' }
        expect(response).to redirect_to(edit_run_path(assigns(:run)))
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
      run = FactoryGirl.create :run
      get :gcinput, id: run, format: :csv
      expect(response).to be_success
    end
  end

  describe 'a run workflow' do
    before(:each) do
      @run = FactoryGirl.create :run
      allow(Run).to receive(:find).and_return(@run)
    end

    describe 'POST reject' do
      it 'rejects a run' do
        allow(@run).to receive('reject!').and_return(true)
        post :reject, id: @run
        expect(response).to redirect_to(runs_path(state: 'rejected'))
      end
    end

    describe 'POST accept' do
      it 'accepts a run' do
        allow(@run).to receive('accept!')
        post :accept, id: @run
        expect(response).to redirect_to(runs_path(state: 'uploaded'))
      end
    end

    describe 'POST approve' do
      it 'approves a run' do
        allow(@run).to receive('approve!')
        post :approve, id: @run
        expect(response).to redirect_to(runs_path(state: 'accepted'))
      end
    end

    describe 'POST publish' do
      it 'publishes a run' do
        allow(@run).to receive('publish!')
        post :publish, id: @run
        expect(response).to redirect_to(runs_path(state: 'approved'))
      end
    end

    describe 'POST unapprove' do
      it 'unapproves a run' do
        allow(@run).to receive('unapprove!')
        post :unapprove, id: @run
        expect(response).to redirect_to(runs_path(state: 'approved'))
      end
    end

    describe 'POST unpublish' do
      it 'unpublishes a run' do
        allow(@run).to receive('unpublish!').and_return(true)
        post :unpublish, id: @run
        expect(response).to redirect_to(runs_path(state: 'published'))
      end
    end
  end
end
