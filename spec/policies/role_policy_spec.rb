require 'rails_helper'
require 'helpers'

RSpec.describe RolePolicy do

  fixtures :users, :roles

  let(:current_user) { nil }
  let(:record) { roles(:default) }
  let(:policy) { RolePolicy.new(current_user, record) }

  %w(show? index? create? edit? update? destroy?).each do |method|
    describe method do
      subject { policy.public_send(method) }

      it 'is false for no user logged in' do
        expect(subject).to be_falsey
      end

      context 'admin logged in' do
        let(:current_user) { users(:admin) }

        it 'is true' do
          expect(subject).to be_truthy
        end
      end
    end
  end

  describe 'updatable_fields' do
    subject { policy.updatable_fields }
    let(:all_fields) { Api::RoleResource._updatable_relationships | Api::RoleResource._attributes.keys - [:id] }

    context 'as admin' do
      let(:current_user) { users(:admin) }
      it 'contains all attributes' do
        expect(subject).to match_array(all_fields)
      end
    end

    context 'as coordinator' do
      let(:current_user) { users(:coordinator) }
      it 'contains all attributes' do
        expect(subject).to match_array(all_fields)
      end
    end

    context 'as leader' do
      let(:current_user) { users(:leader) }
      it 'is empty' do
        expect(subject).to match_array([])
      end
    end
  end
end
