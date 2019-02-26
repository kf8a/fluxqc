# frozen_string_literal: true

require 'rails_helper'

describe StandardCurvesController, type: :controller do
  describe 'an authenticated user' do
    before do
      @user = FactoryBot.create(:user)
      @curve = FactoryBot.create(:standard_curve)
      sign_in @user
    end

    describe "GET 'show'" do
      it 'returns http success' do
        get 'show', params: { id: @curve }
        expect(response).to be_successful
      end
    end

    describe "GET 'update'" do
      it 'returns http success' do
        allow_any_instance_of(StandardCurve).to receive(:run).and_return(Run.new)
        get 'update', params: { id: @curve, data: {} }
        expect(response).to be_successful
      end
    end
  end
end
