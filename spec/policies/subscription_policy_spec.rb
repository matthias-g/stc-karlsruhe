require 'rails_helper'
require 'helpers'

RSpec.describe SubscriptionPolicy do

  include Helpers
  fixtures :users, :subscriptions

  let(:user) { nil }
  let(:record) { subscriptions(:volunteer) }

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

end
