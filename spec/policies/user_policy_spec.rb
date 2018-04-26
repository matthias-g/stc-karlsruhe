require 'rails_helper'
require 'helpers'

RSpec.describe UserPolicy do

  include Fixtures
  include Helpers

  let(:current_user) { nil }
  let(:record) { users(:rolf) }
  let(:policy) { UserPolicy.new(current_user, record) }


  describe 'show?' do
    subject { policy.show? }

    context 'when no user is logged in' do
      it { should_fail }
    end

    context 'for some user' do
      let(:current_user) { users(:sabine) }
      it { should_pass }
      context 'requesting a cleared profile' do
        let(:record) { users(:deleted) }
        it { should_fail }
      end
    end

    context 'for admin requesting a cleared profile' do
      let(:record) { users(:deleted) }
      let(:current_user) { users(:admin) }
      it { should_pass }
    end
  end


  describe 'index?' do
    subject { policy.index? }

    context 'when no user is logged in' do
      it { should_fail }
    end

    context 'for some user' do
      let(:current_user) { users(:sabine) }
      it { should_fail }
    end

    context 'for coordinator' do
      let(:current_user) { users(:coordinator) }
      it { should_pass }
    end

    context 'for admin' do
      let(:current_user) { users(:admin) }
      it { should_pass }
    end
  end


  describe 'edit?' do
    subject { policy.edit? }

    context 'when no user is logged in' do
      it { should_fail }
    end

    context 'for some user' do
      let(:current_user) { users(:sabine) }
      it { should_fail }
    end

    context 'for same user' do
      let(:current_user) { users(record.username) }
      it { should_pass }
    end

    context 'for admin' do
      let(:current_user) { users(:admin) }
      it { should_pass }
    end
  end


  describe 'contact_user?' do
    subject { policy.contact_user? }

    context 'when no user is logged in' do
      it { should_fail }
    end

    context 'for some user' do
      let(:current_user) { users(:sabine) }
      it { should_pass }
    end
  end


  describe 'add_to_actions_as_volunteer?' do
    let(:new_action) { [actions('Kostenlose Fahrradreparatur in der Innenstadt')] }
    subject { policy.add_to_actions_as_volunteer?(new_action) }

    context 'when no user is logged in' do
      it { should_fail }
    end

    context 'for some user' do
      let(:current_user) { users(:sabine) }
      it { should_fail }
    end

    context 'for same user' do
      let(:current_user) { users(:rolf) }
      it { should_pass }
    end
  end


  describe 'permitted_attributes_for_show' do
    subject { policy.permitted_attributes_for_show }

    it 'contains only first name for no user logged in' do
      expect(subject).to contain_exactly(:first_name)
    end

    context 'other user logged in' do
      let(:current_user) { users(:sabine) }

      it 'contains first name and last name' do
        expect(subject).to contain_exactly(:first_name, :last_name)
      end
    end

    context 'same user logged in' do
      let(:current_user) { users(record.username) }

      it 'contains other attributes' do
        expect(subject).to contain_exactly(:username, :first_name, :last_name, :email, :phone,
                                           :receive_emails_about_action_groups, :receive_emails_about_my_action_groups,
                                           :receive_emails_about_other_projects, :receive_other_emails_from_orga,
                                           :receive_emails_from_other_users)
      end
    end

    context 'admin logged in' do
      let(:current_user) { users(:admin) }

      it 'contains other attributes' do
        expect(subject).to contain_exactly(:username, :first_name, :last_name, :email, :phone,
                                           :receive_emails_about_action_groups, :receive_emails_about_my_action_groups,
                                           :receive_emails_about_other_projects, :receive_other_emails_from_orga,
                                           :receive_emails_from_other_users)
      end
    end
  end

  describe 'updatable_fields' do
    subject { policy.updatable_fields }
    let(:all_fields) { Api::UserResource._updatable_relationships | Api::UserResource._attributes.keys - [:id] }

    context 'same user logged in' do
      let(:current_user) { users(record.username) }

      it 'contains other attributes' do
        expect(subject).to match_array(all_fields - [:roles])
      end
    end

    context 'admin logged in' do
      let(:current_user) { users(:admin) }

      it 'contains other attributes' do
        expect(subject).to match_array(all_fields)
      end
    end
  end
end
