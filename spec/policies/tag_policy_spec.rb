require 'rails_helper'
require 'helpers'

RSpec.describe TagPolicy do

  fixtures :users, :tags

  let(:current_user) { nil }
  let(:record) { tags(:default) }
  let(:policy) { TagPolicy.new(current_user, record) }

  describe 'permitted_attributes_for_show' do
    subject { policy.permitted_attributes_for_show }
    it 'permits all fields' do
      expect(subject).to contain_exactly(:title, :initiatives, :icon, :color)
    end
  end

  describe 'updatable_fields' do
    subject { policy.updatable_fields }
    let(:all_fields) { Api::TagResource._updatable_relationships | Api::TagResource._attributes.keys - [:id] }

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
