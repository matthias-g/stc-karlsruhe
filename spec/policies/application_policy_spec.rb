require 'rails_helper'
require 'helpers'

RSpec.describe ApplicationPolicy do

  include Helpers
  fixtures :users, :actions

  let(:current_user) { nil }
  let(:record) { nil }
  let(:policy) { ApplicationPolicy.new(current_user, record) }

  describe 'is_admin?' do
    subject { policy.is_admin? }

    context 'as visitor' do
      it { should_fail }
    end

    context 'as admin' do
      let(:current_user) { users(:admin) }
      it { should_pass }
    end

    context 'as other user' do
      let(:current_user) { users(:leader) }
      it { should_fail }
    end
  end

  describe 'is_coordinator?' do
    subject { policy.is_coordinator? }

    context 'as visitor' do
      it { should_fail }
    end

    context 'as coordinator' do
      let(:current_user) { users(:coordinator) }
      it { should_pass }
    end

    context 'as other user' do
      let(:current_user) { users(:leader) }
      it { should_fail }
    end
  end

  describe 'is_admin_or_coordinator?' do
    subject { policy.is_admin_or_coordinator? }

    context 'as visitor' do
      it { should_fail }
    end

    context 'as admin' do
      let(:current_user) { users(:admin) }
      it { should_pass }
    end

    context 'as coordinator' do
      let(:current_user) { users(:coordinator) }
      it { should_pass }
    end

    context 'as other user' do
      let(:current_user) { users(:leader) }
      it { should_fail }
    end
  end

  %w(index? new? edit? create? update? destroy?).each do |method|
    describe method do
      subject { policy.public_send(method) }
      it { expect(subject).to be(false) } # expects false and not just falsey value as expected by should_fail
    end
  end

  describe 'show?' do
    subject { policy.show? }

    context 'for existing record' do
      let(:record) { actions(:default) }
      it { should_pass }
    end

    context 'for invisible record' do
      let(:record) { actions(:default) }
      before { record.update_attribute(:visible, false) }
      it { should_fail }

      context 'as admin' do
        let(:current_user) { users(:admin) }
        it { should_pass }
      end
    end
  end

  describe 'always' do
    subject { policy.always }
    it { should_pass }
  end

end
