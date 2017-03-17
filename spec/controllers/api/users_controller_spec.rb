require 'rails_helper'
require 'helpers'

RSpec.describe Api::UsersController, type: :controller do

  fixtures :projects, :users, :leaderships, :participations, :roles

  describe 'add role to user' do
    let(:current_user) { :nil }
    let(:role) { roles(:admin) }
    let(:user) { users(:rolf) }

    before do
      sign_in(current_user) if current_user
      request.accept = 'application/vnd.api+json'
      request.content_type = 'application/vnd.api+json'
      post :create_relationship, params: {data: [ {type: 'roles', id: role.id} ], relationship: 'roles', action: 'create_relationship', user_id: user.id}
    end

    context 'no user logged in' do
      it 'should not be successful' do
        expect(response.status).to eq(401)
        expect(user.reload.has_role?(role.title)).to be_falsey
      end
    end

    context 'same user logged in' do
      let(:current_user) { users(:rolf) }

      it 'should not be successful' do
        expect(response.status).to eq(403)
        expect(user.reload.has_role?(role.title)).to be_falsey
      end
    end

    context 'other user logged in' do
      let(:current_user) { users(:sabine) }

      it 'should not be successful' do
        expect(response.status).to eq(403)
        expect(user.reload.has_role?(role.title)).to be_falsey
      end
    end

    context 'admin logged in' do
      let(:current_user) { users(:admin) }

      it 'should be successful' do
        expect(response.status).to eq(204)
        expect(user.reload.has_role?(role.title)).to be_truthy
      end
    end

  end

end
