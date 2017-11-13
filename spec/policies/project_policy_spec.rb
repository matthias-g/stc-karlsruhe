require 'rails_helper'
require 'helpers'

RSpec.describe ProjectPolicy do

  include Fixtures

  let(:user) { nil }
  let(:project) { projects('Kostenlose Fahrradreparatur in der Innenstadt') }
  let(:policy) { ProjectPolicy.new(user, project) }

  permissions :show? do
    subject { described_class }

    it 'grants access if project is visible and no user logged in' do
      expect(subject).to permit(user, project)
    end

    context 'invisible project' do
      let(:project) { projects('Project 3') }

      it 'denies access if no user is logged in' do
        expect(subject).not_to permit(user, project)
      end

      context 'if project leader logged in' do
        let(:user) { users(:rolf) }

        it 'grants access' do
          expect(subject).to permit(user, project)
        end
      end
    end
  end

  describe 'edit?' do
    subject { policy.edit? }

    it 'is false for no user logged in' do
      expect(subject).to be_falsey
    end

    context 'user leads project' do
      let(:user) { users(:rolf) }

      it 'is true' do
        expect(user).to lead_project(project)
        expect(subject).to be_truthy
      end
    end

    context 'user is admin' do
      let(:user) { users(:admin) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end

    context 'user is coordinator' do
      let(:user) { users(:coordinator) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end

    context 'for unrelated user' do
      let(:user) { users(:sabine) }

      it 'is false' do
        expect(user).not_to lead_project(project)
        expect(subject).to be_falsey
      end
    end

    context 'project without leader' do
      let(:project) { projects('Project 2') }

      it 'is false for no user logged in' do
        expect(project.leaders.count).to eq(0)
        expect(subject).to be_falsey
      end
    end
  end

  permissions :create?, :change_visibility? do
    subject { described_class }

    context 'some user is logged in' do
      let(:user) { users(:rolf) }

      it 'denies access' do
        expect(subject).not_to permit(user, project)
      end
    end

    context 'admin is logged in' do
      let(:user) { users(:admin) }

      it 'grants access' do
        expect(subject).to permit(user, project)
      end
    end

    context 'coordinator is logged in' do
      let(:user) { users(:coordinator) }

      it 'grants access' do
        expect(subject).to permit(user, project)
      end
    end
  end

  describe 'index?' do
    subject { policy.index? }

    context 'some user is logged in' do
      let(:user) { users(:rolf) }

      it 'is false' do
        expect(subject).to be_falsey
      end
    end

    context 'admin is logged in' do
      let(:user) { users(:admin) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end

    context 'coordinator is logged in' do
      let(:user) { users(:coordinator) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end
  end

  describe 'contact_volunteers?' do
    subject { policy.contact_volunteers? }

    context 'if project is visible' do
      context 'for project leader' do
        let(:user) { users(:rolf) }

        it 'is true' do
          expect(subject).to be_truthy
        end
      end

      context 'for admin' do
        let(:user) { users(:admin) }

        it 'is true' do
          expect(subject).to be_truthy
        end
      end

      context 'for other users' do
        let(:user) { users(:sabine) }

        it 'is false' do
          expect(subject).to be_falsey
        end
      end
    end

    context 'if project is invisible' do
      before { project.visible = false }

      context 'for project leader' do
        let(:user) { users(:rolf) }

        it 'is false' do
          expect(subject).to be_falsey
        end
      end

      context 'for admin' do
        let(:user) { users(:admin) }

        it 'is false' do
          expect(subject).to be_falsey
        end
      end

      context 'for other users' do
        let(:user) { users(:sabine) }

        it 'is false' do
          expect(subject).to be_falsey
        end
      end
    end
  end

  describe 'contact_leaders?' do
    subject { policy.contact_leaders? }

    context 'if project is open' do
      context 'for volunteer' do
        let(:user) { users(:sabine) }

        it 'is true' do
          expect(subject).to be_truthy
        end
      end

      context 'for other users' do
        let(:user) { users(:peter) }

        it 'is false' do
          expect(subject).to be_falsey
        end
      end
    end

    context 'if project is closed' do
      before { project.close! }

      context 'for volunteer' do
        let(:user) { users(:sabine) }

        it 'is false' do
          expect(subject).to be_falsey
        end
      end

      context 'for other users' do
        let(:user) { users(:peter) }

        it 'is false' do
          expect(subject).to be_falsey
        end
      end
    end
  end

  describe 'upload_pictures?' do
    subject { policy.upload_pictures? }

    context "project's days are in future" do
      before { project.days << ProjectDay.new(date: DateTime.tomorrow) }

      it 'is false for no user logged in' do
        expect(subject).to be_falsey
      end

      context 'project is invisible' do
        let(:project) { projects('Project 3') }

        it 'is false for no user logged in' do
          expect(subject).to be_falsey
        end
      end

      context 'for admin' do
        let(:user) { users(:admin) }

        it 'is false' do
          expect(subject).to be_falsey
        end
      end
    end

    context 'project took place yesterday' do
      before { project.days << ProjectDay.new(date: 1.days.ago) }

      it 'is false for no user logged in' do
        expect(subject).to be_falsey
      end

      context 'project is invisible' do
        let(:project) { projects('Project 3') }

        it 'is false for no user logged in' do
          expect(subject).to be_falsey
        end

        context 'for admin' do
          let(:user) { users(:admin) }

          it 'is false' do
            expect(subject).to be_falsey
          end
        end
      end

      context 'user is project leader' do
        let(:user) { users(:rolf) }

        it 'is true' do
          expect(subject).to be_truthy
        end
      end

      context 'user is admin' do
        let(:user) { users(:admin) }

        it 'is true' do
          expect(subject).to be_truthy
        end
      end

      context 'user is coordinator' do
        let(:user) { users(:coordinator) }

        it 'is true' do
          expect(subject).to be_truthy
        end
      end

      context 'user is volunteer' do
        let(:user) { users(:sabine) }

        it 'is true' do
          expect(subject).to be_truthy
        end
      end

      context 'user is photographer' do
        let(:user) { users(:photographer) }

        it 'is true' do
          expect(subject).to be_truthy
        end
      end

      context 'user is other user' do
        let(:user) { users(:peter) }

        it 'is false' do
          expect(subject).to be_falsey
        end
      end
    end

    context 'project happening today' do
      before { project.days << ProjectDay.new(date: 1.seconds.ago) }
      let(:user) { users(:admin) }

      it 'is true for admin' do
        expect(subject).to be_truthy
      end
    end

    context 'project day has no date' do
      before { project.days << ProjectDay.new(date: nil) }

      it 'is false for no user logged in' do
        expect(subject).to be_falsey
      end
    end
  end

  describe 'add_to_volunteers?' do
    let(:new_volunteers) { [users(:peter)] }
    subject { policy.add_to_volunteers?(new_volunteers) }

    context 'for no user logged in' do
      it 'is false' do
        expect(subject).to be_falsey
      end
    end

    context 'admin is logged in' do
      let(:user) { users(:admin) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end

    context 'other is logged in' do
      let(:user) { users(:sabine) }

      it 'is false' do
        expect(subject).to be_falsey
      end
    end

    context 'user adds themselves' do
      let(:user) { users(:peter) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end

    context 'add multiple users' do
      let(:new_volunteers) { [users(:peter), users(:birgit)] }

      context 'if the first user is logged in' do
        let(:user) { users(:peter) }

        it 'is false' do
          expect(subject).to be_falsey
        end
      end

      context 'if the second user is logged in' do
        let(:user) { users(:birgit) }

        it 'is false' do
          expect(subject).to be_falsey
        end
      end

      context 'admin is logged in' do
        let(:user) { users(:admin) }

        it 'is true' do
          expect(subject).to be_truthy
        end
      end
    end
  end

  describe 'remove_from_volunteers?' do
    let(:user_to_remove) { users(:sabine) }
    subject { policy.remove_from_volunteers?(user_to_remove) }

    context 'some user is logged in' do
      let(:user) { users(:rolf) }

      it 'is false' do
        expect(subject).to be_falsey
      end
    end

    context 'admin is logged in' do
      let(:user) { users(:admin) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end

    context 'user removes themselves' do
      let(:user) { users(:sabine) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end
  end

  describe 'replace_volunteers?' do
    let(:new_volunteers) { [users(:peter)] }
    subject { policy.replace_volunteers?(new_volunteers) }

    context 'some user is logged in' do
      let(:user) { users(:lea) }

      it 'is false' do
        expect(subject).to be_falsey
      end
    end

    context 'admin is logged in' do
      let(:user) { users(:admin) }

      it 'is true' do
        expect(subject).to be_truthy
      end

      context 'adds user to existing users' do
        let(:new_volunteers) { [users(:sabine), users(:peter)] }

        it 'is true' do
          expect(subject).to be_truthy
        end
      end
    end

    context 'user removes themselves but adds someone else' do
      let(:user) { users(:sabine) }

      it 'is false' do
        expect(subject).to be_falsey
      end
    end

    context 'user adds themselves but cannot remove someone else' do
      let(:user) { users(:peter) }

      it 'is false' do
        expect(subject).to be_falsey
      end
    end

    context 'user adds themselves' do
      let(:new_volunteers) { [users(:sabine), users(:peter)] }
      let(:user) { users(:peter) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end
  end

  describe 'enter?' do
    subject { policy.enter? }

    context 'user is not yet volunteer' do
      let(:user) { users(:peter) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end

    context 'user is already volunteering' do
      let(:user) { users(:sabine) }

      it 'is false' do
        expect(subject).to be_falsey
      end
    end
  end

  describe 'leave?' do
    subject { policy.leave? }

    context 'user is volunteer' do
      let(:user) { users(:sabine) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end

    context 'user is not volunteering' do
      let(:user) { users(:peter) }

      it 'is false' do
        expect(subject).to be_falsey
      end
    end
  end

  describe 'updatable_fields' do
    subject { policy.updatable_fields }
    let(:all_fields) { Api::ProjectResource._updatable_relationships | Api::ProjectResource._attributes.keys - [:id] }

    context 'admin logged in' do
      let(:user) { users(:admin) }

      it 'contains all attributes except status and gallery' do
        expect(subject).to match_array(all_fields - [:status, :gallery])
      end
    end

    context 'coordinator logged in' do
      let(:user) { users(:coordinator) }

      it 'contains all attributes except status and gallery' do
        expect(subject).to match_array(all_fields - [:status, :gallery])
      end
    end

    context 'project leader logged in' do
      let(:user) { users(:rolf) }

      it 'contains all attributes except status, gallery and visible' do
        expect(subject).to match_array(all_fields - [:status, :gallery, :visible])
      end
    end
  end

end