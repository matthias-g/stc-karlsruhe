require 'rails_helper'
require 'helpers'

RSpec.describe ProjectPolicy do

  include Helpers
  fixtures :users, :projects, :events

  let(:user) { nil }
  let(:project) { projects(:default_project) }
  let(:event) { events(:project_event) }
  let(:policy) { ProjectPolicy.new(user, project) }

  permissions :show? do
    subject { described_class }

    context 'for visible project' do
      it { grants_access_to_project }
    end

    context 'for invisible project' do
      before { hide_initiative(project) }

      context 'as visitor' do
        it { denies_access_to_project }
      end

      context 'as leader' do
        let(:user) { users(:leader) }
        it { grants_access_to_project }
      end
    end
  end

  describe 'edit?' do
    subject { policy.edit? }

    context 'as visitor' do
      it { should_fail }
    end

    context 'as leader' do
      let(:user) { users(:leader) }
      it { should_pass }

      context 'for finished project' do
        before { finish_initiative(project) }
        it { should_pass }
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

  end

  permissions :create?, :change_visibility? do
    subject { described_class }

    context 'for other user' do
      let(:user) { users(:leader) }
      it { denies_access_to_project }
    end

    context 'as admin' do
      let(:user) { users(:admin) }
      it { grants_access_to_project }
    end

    context 'as coordinator' do
      let(:user) { users(:coordinator) }
      it { grants_access_to_project }
    end
  end

  describe 'index?' do
    subject { policy.index? }

    context 'as other user' do
      let(:user) { users(:leader) }
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

    context 'for invisible project' do
      before { hide_initiative(project) }

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

    context 'for invisible project' do
      before { project.visible = false }

      context 'as volunteer' do
        let(:user) { users(:volunteer) }
        it { should_fail }
      end

      context 'as other user' do
        let(:user) { users(:unrelated) }
        it { should_fail }
      end
    end

    context 'for finished project' do
      before { finish_initiative(project) }

      context 'as volunteer' do
        let(:user) { users(:volunteer) }
        it { should_pass }
      end

      context 'as other user' do
        let(:user) { users(:unrelated) }
        it { should_fail }
      end
    end

  end

  describe 'upload_pictures?' do
    subject { policy.upload_pictures? }

    context 'for future project' do
      before { event.update_attribute :date, Date.tomorrow }

      context 'as visitor' do
        it { should_fail }
      end

      context 'as admin' do
        let(:user) { users(:admin) }
        it { should_pass }
      end
    end

    context 'for past project' do
      before { finish_initiative(project) }

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

    context 'for today project' do
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

      context 'for finished project' do
        before { finish_initiative(project) }
        it { should_pass }
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
    let(:all_fields) { Api::ProjectResource._updatable_relationships | Api::ProjectResource._attributes.keys - [:id] }

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
      let(:user) { users(:leader) }
      it 'contains all attributes except status, gallery and visible' do
        expect(subject).to match_array(all_fields - %i[status gallery visible])
      end
    end
  end

end