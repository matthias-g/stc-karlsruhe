require 'rails_helper'
require 'helpers'

RSpec.describe SubscriptionPolicy do

  include Helpers
  fixtures :users, :subscriptions

  let(:user) { nil }
  let(:record) { subscriptions(:volunteer) }
  let(:policy) { SubscriptionPolicy.new(user, record) }

  permissions :create? do
    subject { described_class }
    it { grants_access }
  end

  permissions :edit? do
    subject { described_class }

    context 'as visitor' do
      it { denies_access }
    end

    context 'as other user' do
      let(:user) { users(:leader) }
      it { denies_access }
    end

    context 'as same user' do
      let(:user) { users(:volunteer) }
      it { grants_access }
    end
  end

  describe 'updatable_fields' do
    subject { policy.updatable_fields }
    let(:all_fields) { Api::SubscriptionResource._updatable_relationships | Api::SubscriptionResource._attributes.keys - [:id] }

    it 'contains all attributes except confirmed_at' do
      expect(subject).to match_array(all_fields - [:confirmed_at])
    end
  end

end
