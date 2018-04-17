require 'rails_helper'
require 'helpers'

RSpec.describe EventPolicy do

  include Fixtures
  include Helpers


  let(:user) { nil }
  let(:event) { actions('Kostenlose Fahrradreparatur in der Innenstadt').events.first }
  let(:policy) { EventPolicy.new(user, event) }

  describe 'add_to_volunteers?' do
    let(:new_volunteers) { [users(:peter)] }
    subject { policy.add_to_volunteers?(new_volunteers) }

    context 'when no user is logged in' do
      it { should_fail }
    end

    context 'as admin' do
      let(:user) { users(:admin) }
      it { should_pass }
    end

    context 'as other user' do
      let(:user) { users(:sabine) }
      it { should_fail }
    end

    context 'when user adds themselves' do
      let(:user) { users(:peter) }
      it { should_pass }
    end

    context 'when multiple users are added' do
      let(:new_volunteers) { [users(:peter), users(:birgit)] }

      context 'as one of the users to be added' do
        let(:user) { users(:peter) }
        it { should_fail }
      end

      context 'as admin' do
        let(:user) { users(:admin) }
        it { should_pass }
      end
    end
  end

  describe 'remove_from_volunteers?' do
    let(:user_to_remove) { users(:sabine) }
    subject { policy.remove_from_volunteers?(user_to_remove) }

    context 'as some user' do
      let(:user) { users(:rolf) }
      it { should_fail }
    end

    context 'as admin' do
      let(:user) { users(:admin) }
      it { should_pass }
    end

    context 'when user removes himself' do
      let(:user) { users(:sabine) }
      it { should_pass }
    end
  end

  describe 'replace_volunteers?' do
    let(:new_volunteers) { [users(:peter)] }
    subject { policy.replace_volunteers?(new_volunteers) }

    context 'as admin' do
      let(:user) { users(:admin) }
      it { should_pass }

      context 'when adding new volunteers' do
        let(:new_volunteers) { [users(:sabine), users(:peter)] }
        it { should_pass }
      end
    end

    context 'as other user' do
      let(:user) { users(:lea) }
      it { should_fail }
    end

    context 'when user removes himself but adds someone else' do
      let(:user) { users(:sabine) }
      it { should_fail }
    end

    context 'when user adds himself but removes someone else' do
      let(:user) { users(:peter) }
      it { should_fail }
    end

    context 'when user adds himself' do
      let(:new_volunteers) { [users(:sabine), users(:peter)] }
      let(:user) { users(:peter) }
      it { should_pass }
    end
  end

  describe 'enter?' do
    subject { policy.enter? }

    context 'as volunteer' do
      let(:user) { users(:sabine) }
      it { should_fail }
    end

    context 'as other user' do
      let(:user) { users(:peter) }
      it { should_pass }
    end
  end

  describe 'leave?' do
    subject { policy.leave? }

    context 'as volunteer' do
      let(:user) { users(:sabine) }
      it { should_pass }
    end

    context 'as other user' do
      let(:user) { users(:peter) }
      it { should_fail }
    end
  end

  describe 'delete_volunteer?' do
    subject { policy.delete_volunteer? }

    context 'as leader' do
      let(:user) { users(:rolf) }
      it { should_pass }
    end

    context 'as admin' do
      let(:user) { users(:admin) }
      it { should_pass }

      context 'for finished event' do
        before { event.update_attribute :date, Date.yesterday }
        it { should_fail }
      end
    end

    context 'as coordinator' do
      let(:user) { users(:coordinator) }
      it { should_pass }
    end

    context 'as other user' do
      let(:user) { users(:peter) }
      it { should_fail }
    end
  end

  describe 'updatable_fields' do
    subject { policy.updatable_fields }
    let(:all_fields) { Api::EventResource._updatable_relationships | Api::EventResource._attributes.keys - [:id] }

    context 'as admin' do
      let(:user) { users(:admin) }
      it 'contains all attributes except team size' do
        expect(subject).to match_array(all_fields - %i[team_size])
      end
    end
  end

  describe 'scope' do
    subject { EventPolicy::Scope.new(user, Event.all).resolve }
    let(:invisible_event) { actions('Action 3').events.first }

    context 'as admin' do
      let(:user) { users(:admin) }
      it 'does contain invisible events' do
        expect(subject).to include(invisible_event)
      end
    end

    context 'as not logged in user' do
      let(:user) { nil }
      it 'does not contain invisible events' do
        expect(subject).not_to include(invisible_event)
      end
    end

    context 'as leader' do
      let(:user) { users(:rolf) }
      it 'does contain invisible event' do
        expect(subject).to include(invisible_event)
      end
    end
  end

end