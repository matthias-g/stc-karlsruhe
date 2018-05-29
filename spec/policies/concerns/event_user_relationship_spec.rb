require 'rails_helper'
require 'helpers'

shared_examples 'a EventUserRelationship' do

  include Helpers
  fixtures :users, :actions, :events

  let(:relationship) { described_class.new(current_user, nil) }

  let(:current_user) { nil }
  let(:user) { users(:subaction_volunteer) }
  let(:action) { actions(:default) }
  let(:event) { events(:default) }

  describe 'allow_add_volunteer_to_event?' do
    subject { relationship.allow_add_volunteer_to_event?(user, event) }

    context 'as visitor' do
      it { should_fail }
    end

    context 'as same user' do

      # this tests for correct execution when user and current_user are equal but not identical (eql? but not equal?)
      # so we can't use 'user' or 'users(:subaction_volunteer)'
      let(:current_user) { User.find_by_username(:subaction_volunteer) }

      it { should_pass }
    end

    context 'as leader' do
      let(:current_user) { users(:leader) }
      it { should_pass }

      context 'for finished action' do
        before { action.events.first.update_attribute :date, Date.yesterday }
        it { should_fail }
      end
    end

    context 'as admin' do
      let(:current_user) { users(:admin) }
      it { should_pass }

      context 'for volunteer' do
        let(:user) { users(:volunteer) }
        it { should_fail }
      end

      context 'for finished action' do
        before { event.update_attribute :date, Date.yesterday }
        it { should_pass }
      end

      context 'for full action' do
        before { event.update_attribute :desired_team_size, event.volunteers.count }
        it { should_fail }
      end
    end

    context 'as coordinator' do
      let(:current_user) { users(:coordinator) }
      it { should_pass }
    end
  end

  describe 'allow_remove_volunteer_from_event?' do
    subject { relationship.allow_remove_volunteer_from_event?(user, event) }
    let(:user) { users(:volunteer) }

    context 'as visitor' do
      it { should_fail }
    end

    context 'as same user' do
      let(:current_user) { user }
      it { should_pass }

      context 'action is finished' do
        before { event.update_attribute :date, Date.yesterday }
        it { should_fail }
      end
    end

    context 'as other user' do
      let(:current_user) { users(:unrelated) }
      it { should_fail }
    end

    context 'as admin' do
      let(:current_user) { users(:admin) }
      it { should_pass }

      context 'for non-volunteer' do
        let(:user) { users(:subaction_volunteer) }
        it { should_fail }
      end

      context 'for finished action' do
        before { event.update_attribute :date, Date.yesterday }
        it { should_pass }
      end
    end

    context 'as coordinator' do
      let(:current_user) { users(:coordinator) }
      it { should_pass }
    end
  end

end

describe UserPolicy do
  it_behaves_like 'a EventUserRelationship'
end

describe EventPolicy do
  it_behaves_like 'a EventUserRelationship'
end