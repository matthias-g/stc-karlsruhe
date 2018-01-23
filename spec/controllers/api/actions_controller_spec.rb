require 'rails_helper'
require 'helpers'

RSpec.describe Api::ActionsController, type: :controller do

  fixtures :actions, :users, :leaderships, :participations, :roles

  describe 'GET #show' do
    let(:user) { :nil }

    before do
      sign_in(user) if user
      request.accept = 'application/vnd.api+json'
      get :show, params: { id: action.id }
    end

    context 'action is visible' do
      let(:action) { actions(:one) }

      it 'should be successful' do
        expect(response.status).to eq(200)
      end

      it 'should return the correct action' do
        response_data = JSON.parse(response.body)['data']
        expect(response_data['id'].to_i).to eq(action.id)
      end
    end

    context 'action is invisible' do
      let(:action) { actions(:three) }

      it 'should not be found' do
        expect(response.status).to be 404
      end

      context 'action leader is signed in' do
        let(:user) { users(:rolf) }

        it 'should be successful' do
          expect(response.status).to be 200
        end
      end
    end


  end

end
