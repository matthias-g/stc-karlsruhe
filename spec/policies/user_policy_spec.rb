require 'rails_helper'
require 'helpers'

RSpec.describe UserPolicy do

  include Helpers
  fixtures :all

  let(:current_user) { nil }
  let(:record) { users(:volunteer) }
  let(:policy) { UserPolicy.new(current_user, record) }


  describe 'show?' do
    subject { policy.show? }

    context 'as visitor' do
      it { should_fail }
    end

    context 'as other user' do
      let(:current_user) { users(:unrelated) }
      it { should_pass }
      context 'requesting a cleared profile' do
        let(:record) { users(:deleted) }
        it { should_fail }
      end
    end

    context 'as admin requesting a cleared profile' do
      let(:record) { users(:deleted) }
      let(:current_user) { users(:admin) }
      it { should_pass }
    end
  end


  describe 'index?' do
    subject { policy.index? }

    context 'as visitor' do
      it { should_fail }
    end

    context 'as other user' do
      let(:current_user) { users(:unrelated) }
      it { should_fail }
    end

    context 'as coordinator' do
      let(:current_user) { users(:coordinator) }
      it { should_pass }
    end

    context 'as admin' do
      let(:current_user) { users(:admin) }
      it { should_pass }
    end
  end


  describe 'edit?' do
    subject { policy.edit? }

    context 'as visitor' do
      it { should_fail }
    end

    context 'as other user' do
      let(:current_user) { users(:unrelated) }
      it { should_fail }
    end

    context 'as same user' do
      let(:current_user) { users(record.username) }
      it { should_pass }
    end

    context 'as admin' do
      let(:current_user) { users(:admin) }
      it { should_pass }
    end
  end


  describe 'contact_user?' do
    subject { policy.contact_user? }

    context 'as visitor' do
      it { should_fail }
    end

    context 'as other user' do
      let(:current_user) { users(:unrelated) }
      it { should_pass }
    end
  end

  describe 'unsubscribe?' do
    subject { policy.unsubscribe? }

    context 'as visitor' do
      it { should_pass }
    end

    context 'as other user' do
      let(:current_user) { users(:unrelated) }
      it { should_pass }
    end
  end


  describe 'permitted_attributes_for_show' do
    subject { policy.permitted_attributes_for_show }

    context 'as visitor' do
      it 'contains only first name' do
        expect(subject).to contain_exactly(:first_name)
      end
    end

    context 'as other user' do
      let(:current_user) { users(:unrelated) }
      it 'contains first name and last name' do
        expect(subject).to contain_exactly(:first_name, :last_name)
      end
    end

    context 'as same user' do
      let(:current_user) { users(record.username) }
      it 'contains other attributes' do
        expect(subject).to contain_exactly(:username, :first_name, :last_name, :email, :phone,
                                           :receive_emails_about_action_groups, :receive_emails_about_my_action_groups,
                                           :receive_emails_about_other_projects, :receive_other_emails_from_orga,
                                           :receive_emails_from_other_users)
      end
    end

    context 'as admin' do
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

    context 'as same user' do
      let(:current_user) { users(record.username) }
      it 'contains other attributes' do
        expect(subject).to match_array(all_fields - [:roles])
      end
    end

    context 'as admin' do
      let(:current_user) { users(:admin) }
      it 'contains other attributes' do
        expect(subject).to match_array(all_fields)
      end
    end
  end
end
