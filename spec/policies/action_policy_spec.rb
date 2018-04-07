require 'rails_helper'
require 'helpers'

RSpec.describe ActionPolicy do

  include Fixtures
  include Helpers


  let(:user) { nil }
  let(:action) { actions('Kostenlose Fahrradreparatur in der Innenstadt') }
  let(:policy) { ActionPolicy.new(user, action) }

  permissions :show? do
    subject { described_class }

    it 'grants access if action is visible and no user logged in' do
      expect(subject).to permit(user, action)
    end

    context 'for invisible action' do
      let(:action) { actions('Action 3') }

      it 'denies access if no user is logged in' do
        expect(subject).not_to permit(user, action)
      end

      context 'as leader' do
        let(:user) { users(:rolf) }

        it 'grants access' do
          expect(subject).to permit(user, action)
        end
      end
    end
  end

  describe 'edit?' do
    subject { policy.edit? }

    context 'when no user is logged in' do
      it { should_fail }
    end

    context 'as leader' do
      let(:user) { users(:rolf) }
      it { should_pass }
    end

    context 'as admin' do
      let(:user) { users(:admin) }
      it { should_pass }
    end

    context 'as coordinator' do
      let(:user) { users(:coordinator) }
      it { should_pass }
    end

    context 'as other user' do
      let(:user) { users(:sabine) }
      it { should_fail }
    end

  end

  permissions :create?, :change_visibility? do
    subject { described_class }

    context 'for some user' do
      let(:user) { users(:rolf) }
      it 'denies access' do
        expect(subject).not_to permit(user, action)
      end
    end

    context 'as admin' do
      let(:user) { users(:admin) }
      it 'grants access' do
        expect(subject).to permit(user, action)
      end
    end

    context 'as coordinator' do
      let(:user) { users(:coordinator) }
      it 'grants access' do
        expect(subject).to permit(user, action)
      end
    end
  end

  describe 'index?' do
    subject { policy.index? }

    context 'as some user' do
      let(:user) { users(:rolf) }
      it { should_fail }
    end

    context 'as admin' do
      let(:user) { users(:admin) }
      it { should_pass }
    end

    context 'as coordinator' do
      let(:user) { users(:coordinator) }
      it { should_pass }
    end
  end

  describe 'contact_volunteers?' do
    subject { policy.contact_volunteers? }

    context 'as leader' do
      let(:user) { users(:rolf) }
      it { should_pass }
    end

    context 'as admin' do
      let(:user) { users(:admin) }
      it { should_pass }
    end

    context 'as other user' do
      let(:user) { users(:sabine) }
      it { should_fail }
    end

    context 'for invisible action' do
      before { action.visible = false }

      context 'as leader' do
        let(:user) { users(:rolf) }
        it { should_fail }
      end

      context 'as admin' do
        let(:user) { users(:admin) }
        it { should_fail }
      end

      context 'as other user' do
        let(:user) { users(:sabine) }
        it { should_fail }
      end
    end
  end

  describe 'contact_leaders?' do
    subject { policy.contact_leaders? }

    context 'as volunteer' do
      let(:user) { users(:sabine) }
      it { should_pass }
    end

    context 'as other user' do
      let(:user) { users(:peter) }
      it { should_fail }
    end

    context 'for invisible action' do
      before { action.visible = false }

      context 'as volunteer' do
        let(:user) { users(:sabine) }
        it { should_fail }
      end

      context 'as other user' do
        let(:user) { users(:peter) }
        it { should_fail }
      end
    end

    context 'for finished action' do
      before { action.events.first.update_attribute :date, Date.yesterday }

      context 'as volunteer' do
        let(:user) { users(:sabine) }
        it { should_fail }
      end

      context 'as other user' do
        let(:user) { users(:peter) }
        it { should_fail }
      end
    end

  end

  describe 'upload_pictures?' do
    subject { policy.upload_pictures? }

    context 'for future action' do
      before { action.events.first.update_attribute :date, Date.tomorrow }

      context 'when no user is logged in' do
        it { should_fail }
      end

      context 'for admin' do
        let(:user) { users(:admin) }
        it { should_fail }
      end
    end

    context 'for past action' do
      before { action.events.first.update_attribute :date, 1.days.ago }

      context 'when no user is logged in' do
        it { should_fail }
      end

      context 'as leader' do
        let(:user) { users(:rolf) }
        it { should_pass }
      end

      context 'as admin' do
        let(:user) { users(:admin) }
        it { should_pass }
      end

      context 'as coordinator' do
        let(:user) { users(:coordinator) }
        it { should_pass }
      end

      context 'as volunteer' do
        let(:user) { users(:sabine) }
        it { should_pass }
      end

      context 'as photographer' do
        let(:user) { users(:photographer) }
        it { should_pass }
      end

      context 'as other user' do
        let(:user) { users(:peter) }
        it { should_fail }
      end
    end

    context 'for today action' do
      before { action.events.first.update_attribute :date, 1.seconds.ago }
      let(:user) { users(:admin) }
      it { should_pass }
    end

    context 'for undated action' do
      before { action.events.first.update_attribute :date, nil }
      it { should_fail }
    end
  end

  describe 'manage_team?' do
    subject { policy.manage_team? }

    context 'as action leader' do
      let(:user) { users(:rolf) }
      it { should_pass }
    end

    context 'as admin' do
      let(:user) { users(:admin) }
      it { should_pass }
    end

    context 'as other user' do
      let(:user) { users(:sabine) }
      it { should_fail }
    end

    context 'for finished action' do
      before { action.events.first.update_attribute :date, Date.yesterday }
      it { should_fail }
    end

  end

  describe 'enter_subaction?' do
    subject { policy.enter_subaction? }
    let(:action) { actions('Fest im Kindergarten') }

    context 'with full sub actions' do
      before { action.subactions.each { |a| a.events.first.update_attribute('desired_team_size', 1) } }
      it { should_fail }
    end

    context 'for finished action' do
      before { ([action] + action.subactions).each { |a| a.events.first.update_attribute :date, Date.yesterday } }
      it { should_fail }
    end

    context 'for active action' do
      before { action.events.first.update_attribute :date, Date.today }


      context 'with non-full sub actions' do
        before { action.subactions.each { |a| a.events.first.update_attribute('desired_team_size', 2) }  }

        context 'if user already is in a subaction' do
          let(:user) { users(:lea) }
          it { should_fail }
        end

        context 'if user is in no subaction' do
          let(:user) { users(:sabine) }
          it { should_pass }
        end
      end
    end
  end

  describe 'updatable_fields' do
    subject { policy.updatable_fields }
    let(:all_fields) { Api::ActionResource._updatable_relationships | Api::ActionResource._attributes.keys - [:id] }

    context 'as admin' do
      let(:user) { users(:admin) }
      it 'contains all attributes except status and gallery' do
        expect(subject).to match_array(all_fields - %i[status gallery])
      end
    end

    context 'as coordinator' do
      let(:user) { users(:coordinator) }
      it 'contains all attributes except status and gallery' do
        expect(subject).to match_array(all_fields - %i[status gallery])
      end
    end

    context 'as leader' do
      let(:user) { users(:rolf) }
      it 'contains all attributes except status, gallery and visible' do
        expect(subject).to match_array(all_fields - %i[status gallery visible])
      end
    end
  end

end