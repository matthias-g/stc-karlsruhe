require 'rails_helper'
require 'helpers'

RSpec.describe UserPolicy do

  include Fixtures

  let(:current_user) { nil }
  let(:record) { users(:rolf) }
  let(:policy) { UserPolicy.new(current_user, record) }

  describe 'show?' do
    subject { policy.show? }

    it 'does not show for no user logged in' do
      expect(subject).to be(false)
    end

    context 'other user logged in' do
      let(:current_user) { users(:sabine) }

      it 'does show user' do
        expect(subject).to be_truthy
      end

      context 'user has been cleared' do
        let(:record) { users(:deleted) }
        it 'does not show user' do
          expect(subject).to be_falsey
        end
      end
    end

    context 'admin logged in and user has been cleared' do
      let(:record) { users(:deleted) }
      let(:current_user) { users(:admin) }

      it 'does show user' do
        expect(subject).to be_truthy
      end
    end
  end

  describe 'index?' do
    subject { policy.index? }

    it 'is false for no user logged in' do
      expect(subject).to be_falsey
    end

    context 'other user logged in' do
      let(:current_user) { users(:sabine) }

      it 'is false' do
        expect(subject).to be_falsey
      end
    end

    context 'admin logged in' do
      let(:current_user) { users(:admin) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end
  end

  describe 'edit?' do
    subject { policy.edit? }

    it 'is false for no user logged in' do
      expect(subject).to be(false)
    end

    context 'other user logged in' do
      let(:current_user) { users(:sabine) }

      it 'is false' do
        expect(subject).to be_falsey
      end
    end

    context 'same user logged in' do
      let(:current_user) { users(record.username) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end

    context 'admin logged in' do
      let(:current_user) { users(:admin) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end
  end

  describe 'contact_user?' do
    subject { policy.contact_user? }

    it 'is false for no user logged in' do
      expect(subject).to be(false)
    end

    context 'other user logged in' do
      let(:current_user) { users(:sabine) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end
  end

  describe 'add_to_projects_as_volunteer?' do
    let(:new_projects) { [projects('Kostenlose Fahrradreparatur in der Innenstadt')] }
    subject { policy.add_to_projects_as_volunteer?(new_projects) }

    it 'is false for no user logged in' do
      expect(subject).to be(false)
    end

    context 'other user logged in' do
      let(:current_user) { users(:sabine) }

      it 'is false' do
        expect(subject).to be_falsey
      end
    end

    context 'same user logged in' do
      let(:current_user) { users(:rolf) }

      it 'is true' do
        expect(subject).to be_truthy
      end
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
                                           :receive_emails_about_project_weeks, :receive_emails_about_my_project_weeks,
                                           :receive_emails_about_other_projects, :receive_other_emails_from_orga,
                                           :receive_emails_from_other_users)
      end
    end

    context 'admin logged in' do
      let(:current_user) { users(:admin) }

      it 'contains other attributes' do
        expect(subject).to contain_exactly(:username, :first_name, :last_name, :email, :phone,
                                           :receive_emails_about_project_weeks, :receive_emails_about_my_project_weeks,
                                           :receive_emails_about_other_projects, :receive_other_emails_from_orga,
                                           :receive_emails_from_other_users)
      end
    end
  end
end
