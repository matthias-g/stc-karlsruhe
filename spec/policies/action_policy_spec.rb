require 'rails_helper'
require 'helpers'

RSpec.describe ActionPolicy do

  include Helpers
  fixtures :users, :actions, :events

  let(:user) { nil }
  let(:action) { actions(:default) }
  let(:event) { events(:default) }
  let(:policy) { ActionPolicy.new(user, action) }

  permissions :show? do
    subject { described_class }

    context 'for visible action' do
      it { grants_access }
    end

    context 'for invisible action' do
      before { hide_initiative(action) }

      context 'as visitor' do
        it { denies_access }
      end

      context 'as leader' do
        let(:user) { users(:leader) }
        it { grants_access }
      end
    end
  end

  permissions :edit?, :add_to_leaders?, :remove_from_leaders? do
    subject { described_class }

    context 'as visitor' do
      it { denies_access }
    end

    context 'as leader' do
      let(:user) { users(:leader) }
      it { grants_access }

      context 'for finished action' do
        before { finish_initiative(action) }
        it { denies_access }
      end
    end

    context 'as admin' do
      let(:user) { users(:admin) }
      it { grants_access }
    end

    context 'as coordinator' do
      let(:user) { users(:coordinator) }
      it { grants_access }
    end

    context 'as other user' do
      let(:user) { users(:volunteer) }
      it { denies_access }
    end

  end

  permissions :create?, :change_visibility? do
    subject { described_class }

    context 'for other user' do
      let(:user) { users(:leader) }
      it { denies_access }
    end

    context 'as admin' do
      let(:user) { users(:admin) }
      it { grants_access }
    end

    context 'as coordinator' do
      let(:user) { users(:coordinator) }
      it { grants_access }
    end
  end

  describe 'index?' do
    subject { policy.index? }

    context 'as other user' do
      let(:user) { users(:leader) }
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
  end

  describe 'contact_volunteers?' do
    subject { policy.contact_volunteers? }

    context 'as leader' do
      let(:user) { users(:leader) }
      it { should_pass }
    end

    context 'as admin' do
      let(:user) { users(:admin) }
      it { should_pass }
    end

    context 'as other user' do
      let(:user) { users(:volunteer) }
      it { should_fail }
    end

    context 'for invisible action' do
      before { hide_initiative(action) }

      context 'as leader' do
        let(:user) { users(:leader) }
        it { should_fail }
      end

      context 'as admin' do
        let(:user) { users(:admin) }
        it { should_fail }
      end

      context 'as other user' do
        let(:user) { users(:volunteer) }
        it { should_fail }
      end
    end
  end

  describe 'contact_leaders?' do
    subject { policy.contact_leaders? }

    context 'as volunteer' do
      let(:user) { users(:volunteer) }
      it { should_pass }
    end

    context 'as other user' do
      let(:user) { users(:unrelated) }
      it { should_fail }
    end

    context 'for invisible action' do
      before { action.visible = false }

      context 'as volunteer' do
        let(:user) { users(:volunteer) }
        it { should_fail }
      end

      context 'as other user' do
        let(:user) { users(:unrelated) }
        it { should_fail }
      end
    end

    context 'for finished action' do
      before { finish_initiative(action) }

      context 'as volunteer' do
        let(:user) { users(:volunteer) }
        it { should_fail }
      end

      context 'as other user' do
        let(:user) { users(:unrelated) }
        it { should_fail }
      end
    end

  end

  describe 'upload_pictures?' do
    subject { policy.upload_pictures? }

    context 'for future action' do
      before { event.update_attribute :date, Date.tomorrow }

      context 'as visitor' do
        it { should_fail }
      end

      context 'as admin' do
        let(:user) { users(:admin) }
        it { should_fail }
      end
    end

    context 'for past action' do
      before { finish_initiative(action) }

      context 'as visitor' do
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

      context 'as coordinator' do
        let(:user) { users(:coordinator) }
        it { should_pass }
      end

      context 'as volunteer' do
        let(:user) { users(:volunteer) }
        it { should_pass }
      end

      context 'as photographer' do
        let(:user) { users(:photographer) }
        it { should_pass }
      end

      context 'as other user' do
        let(:user) { users(:unrelated) }
        it { should_fail }
      end
    end

    context 'for today action' do
      before { event.update_attribute :date, 1.seconds.ago }
      let(:user) { users(:admin) }
      it { should_pass }
    end
  end

  describe 'manage_team?' do
    subject { policy.manage_team? }

    context 'as leader' do
      let(:user) { users(:leader) }
      it { should_pass }

      context 'for finished action' do
        before { finish_initiative(action) }
        it { should_fail }
      end
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
      let(:user) { users(:volunteer) }
      it { should_fail }
    end

    context 'as visitor' do
      let(:user) { nil }
      it { should_fail }
    end
  end

  describe 'updatable_fields' do
    subject { policy.updatable_fields }
    let(:all_fields) { Api::ActionResource._updatable_relationships | Api::ActionResource._attributes.keys - [:id] }

    context 'as admin' do
      let(:user) { users(:admin) }
      it 'contains all attributes except status and gallery' do
        expect(subject).to match_array(all_fields - %i[status gallery info])
      end
    end

    context 'as coordinator' do
      let(:user) { users(:coordinator) }
      it 'contains all attributes except status and gallery' do
        expect(subject).to match_array(all_fields - %i[status gallery info])
      end
    end

    context 'as leader' do
      let(:user) { users(:leader) }
      it 'contains all attributes except status, gallery and visible' do
        expect(subject).to match_array(all_fields - %i[status gallery info visible])
      end
    end
  end

end
