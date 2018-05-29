require 'rails_helper'
require 'helpers'

RSpec.describe Api::UsersController, type: :controller do

  fixtures :all

  describe 'add role to user' do
    let(:current_user) { :nil }
    let(:role) { roles(:admin) }
    let(:user) { users(:leader) }

    before do
      sign_in(current_user) if current_user
      request.accept = 'application/vnd.api+json'
      request.content_type = 'application/vnd.api+json'
      post :create_relationship, params: {data: [ {type: 'roles', id: role.id} ], relationship: 'roles', action: 'create_relationship', user_id: user.id}
    end

    context 'as visitor' do
      it 'should be unauthorized or bad request' do
        expect(response.status).to eq(401).or eq(400)
        expect(user.reload.has_role?(role.title)).to be_falsey
      end
    end

    context 'as same user' do
      let(:current_user) { user }

      it 'should be forbidden or bad request' do
        expect(response.status).to eq(403).or eq(400)
        expect(user.reload.has_role?(role.title)).to be_falsey
      end
    end

    context 'as other user' do
      let(:current_user) { users(:unrelated) }

      it 'should be forbidden or bad request' do
        expect(response.status).to eq(403).or eq(400)
        expect(user.reload.has_role?(role.title)).to be_falsey
      end
    end

    context 'as admin' do
      let(:current_user) { users(:admin) }

      it 'should be successful' do
        expect(response.status).to eq(204)
        expect(user.reload.has_role?(role.title)).to be_truthy
      end
    end

  end

end
