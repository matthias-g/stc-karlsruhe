require 'rails_helper'
require 'helpers'

RSpec.describe ProjectPolicy do
  fixtures :projects, :users

  let(:user) { nil }
  let(:project) { projects(:one) }
  let(:policy) { ProjectPolicy.new(user, project) }

  before do
    policy = ProjectPolicy.new(user, project)
  end

  describe 'show?' do
    subject { policy.show? }

    context 'visible project' do
      it 'does show for no user logged in' do
        expect(subject).to be_truthy
      end
    end

    context 'invisible project' do
      let(:project) { projects(:three) }

      it 'does not show for no user logged in' do
        expect(subject).to be_falsey
      end

      context 'project leader logged in' do
        let(:user) { users(:rolf) }

        it 'does show' do
          expect(subject).to be_truthy
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

    context 'for unrelated user' do
      let(:user) { users(:sabine) }

      it 'is false' do
        expect(user).not_to lead_project(project)
        expect(subject).to be_falsey
      end
    end

    context 'project without leader' do
      let(:project) { projects(:two) }

      it 'is false for no user logged in' do
        expect(project.leaders.count).to eq(0)
        expect(subject).to be_falsey
      end
    end
  end

  describe 'create?' do
    subject { policy.create? }

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

  describe 'upload_pictures?' do
    subject { policy.upload_pictures? }

    context "project's days are in future" do
      before { project.days << ProjectDay.new(date: DateTime.tomorrow) }

      it 'is false for no user logged in' do
        expect(subject).to be_falsey
      end

      context 'project is invisible' do
        let(:project) { projects(:three) }

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
        let(:project) { projects(:three) }

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
      before { project.days << ProjectDay.new(date: Time.now + 10.minutes) }
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

end