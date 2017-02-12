require 'rails_helper'
require 'helpers'

RSpec.describe Api::ProjectsController, type: :controller do

  fixtures :projects, :users, :leaderships, :participations, :roles

  describe 'GET #show' do
    let(:user) { :nil }

    before do
      sign_in(user) if user
      request.accept = 'application/vnd.api+json'
      get :show, params: { id: project.id }
    end

    context 'project is visible' do
      let(:project) { projects(:one) }

      it 'should be successful' do
        expect(response.status).to eq(200)
      end

      it 'should return the correct project' do
        response_data = JSON.parse(response.body)['data']
        expect(response_data['id'].to_i).to eq(project.id)
      end
    end

    context 'project is invisible' do
      let(:project) { projects(:three) }

      it 'should not be found' do
        expect(response.status).to be 404
      end

      context 'project leader is signed in' do
        let(:user) { users(:rolf) }

        it 'should be successful' do
          expect(response.status).to be 200
        end
      end
    end


  end

end
