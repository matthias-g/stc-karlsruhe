require 'rails_helper'
require 'helpers'

RSpec.describe EventPolicy do

  include Helpers
  fixtures :events, :actions, :users


  let(:user) { nil }
  let(:event) { events(:default) }
  let(:policy) { EventPolicy.new(user, event) }

  describe 'add_to_volunteers?' do
    let(:new_volunteers) { [users(:unrelated)] }
    subject { policy.add_to_volunteers?(new_volunteers) }

    context 'as visitor' do
      it { should_fail }
    end

    context 'as admin' do
      let(:user) { users(:admin) }
      it { should_pass }
    end

    context 'as other user' do
      let(:user) { users(:volunteer) }
      it { should_fail }
    end

    context 'as same user' do
      let(:user) { users(:unrelated) }
      it { should_pass }
    end

    context 'when multiple users are added' do
      let(:new_volunteers) { [users(:unrelated), users(:unrelated_2)] }

      context 'as one of the users to be added' do
        let(:user) { users(:unrelated) }
        it { should_fail }
      end

      context 'as admin' do
        let(:user) { users(:admin) }
        it { should_pass }
      end
    end
  end

  describe 'remove_from_volunteers?' do
    let(:user_to_remove) { users(:volunteer) }
    subject { policy.remove_from_volunteers?(user_to_remove) }

    context 'as some user' do
      let(:user) { users(:unrelated) }
      it { should_fail }
    end

    context 'as leader' do
      let(:user) { users(:leader) }
      it { should_pass }
    end

    context 'as admin' do
      let(:user) { users(:admin) }
      it { should_pass }
    end

    context 'as same user' do
      let(:user) { users(:volunteer) }
      it { should_pass }
    end
  end

  describe 'replace_volunteers?' do
    let(:new_volunteers) { [users(:unrelated)] }
    subject { policy.replace_volunteers?(new_volunteers) }

    context 'as admin' do
      let(:user) { users(:admin) }
      it { should_pass }

      context 'when adding volunteers' do
        let(:new_volunteers) { [users(:unrelated), users(:unrelated_2)] }
        it { should_pass }
      end
    end

    context 'as other user' do
      let(:user) { users(:photographer) }
      it { should_fail }
    end

    context 'when user removes himself but adds someone else' do
      let(:user) { users(:volunteer) }
      let(:new_volunteers) { [users(:ancient_user), users(:unrelated)] }
      it { should_fail }
    end

    context 'when user adds himself but removes others' do
      let(:user) { users(:unrelated) }
      it { should_fail }
    end

    context 'when user adds himself' do
      let(:new_volunteers) { [users(:volunteer), users(:ancient_user), users(:unrelated)] }
      let(:user) { users(:unrelated) }
      it { should_pass }
    end
  end

  describe 'enter?' do
    subject { policy.enter? }

    context 'as volunteer' do
      let(:user) { users(:volunteer) }
      it { should_fail }
    end

    context 'as other user' do
      let(:user) { users(:unrelated) }
      it { should_pass }
    end
  end

  describe 'leave?' do
    subject { policy.leave? }

    context 'as volunteer' do
      let(:user) { users(:volunteer) }
      it { should_pass }
    end

    context 'as other user' do
      let(:user) { users(:unrelated) }
      it { should_fail }
    end
  end



  describe 'manage_team?' do
    subject { policy.manage_team? }

    context 'as leader' do
      let(:user) { users(:leader) }
      it { should_pass }

      context 'for finished event' do
        before { finish_initiative(event.initiative) }
        it { should_fail }
      end
    end

    context 'as admin' do
      let(:user) { users(:admin) }
      it { should_pass }

      context 'for finished event' do
        before { finish_initiative(event.initiative) }
        it { should_pass }
      end
    end

    context 'as coordinator' do
      let(:user) { users(:coordinator) }
      it { should_pass }
    end

    context 'as other user' do
      let(:user) { users(:volunteer) }
      it { should_fail }
    end
  end

  describe 'updatable_fields' do
    subject { policy.updatable_fields }
    let(:all_fields) { Api::EventResource._updatable_relationships | Api::EventResource._attributes.keys - [:id] }

    context 'as admin' do
      let(:user) { users(:admin) }
      it 'contains all attributes except team size' do
        expect(subject).to match_array(all_fields - %i[team_size start_time end_time])
      end
    end
  end

  describe 'scope' do
    subject { EventPolicy::Scope.new(user, Event.all).resolve }
    let(:invisible_event) { actions(:default).events.first }
    before { invisible_event.initiative.update_attribute :visible, false }

    context 'as admin' do
      let(:user) { users(:admin) }
      it 'does contain invisible events' do
        expect(subject).to include(invisible_event)
      end
    end

    context 'as visitor' do
      let(:user) { nil }
      it 'does not contain invisible events' do
        expect(subject).not_to include(invisible_event)
      end
    end

    context 'as leader' do
      let(:user) { users(:leader) }
      it 'does contain invisible event' do
        expect(subject).to include(invisible_event)
      end
    end
  end

end