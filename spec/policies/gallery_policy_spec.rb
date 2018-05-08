require 'rails_helper'
require 'helpers'

RSpec.describe GalleryPolicy do

  include Fixtures
  include Helpers

  let(:current_user) { nil }
  let(:record) { Gallery.find_by(title: 'GalleryOne') }
  let(:policy) { GalleryPolicy.new(current_user, record) }

  %w(index? new? create? destroy?).each do |method|
    describe method do
      subject { policy.public_send(method) }

      context 'as visitor' do
        it { should_fail }
      end

      context 'as admin' do
        let(:current_user) { users(:admin) }
        it { should_pass }
      end
    end
  end

  %w(edit? make_all_visible? make_all_invisible?).each do |method|
    describe method do
      subject { policy.public_send(method) }

      context 'as visitor' do
        it { should_fail }
      end

      context 'as admin' do
        let(:current_user) { users(:admin) }
        it { should_pass }
      end

      context 'as coordinator' do
        let(:current_user) { users(:coordinator) }
        it { should_pass }
      end
    end
  end

  describe 'show?' do
    subject { policy.show? }

    context 'as visitor' do
      it { should_pass }
    end

    context 'for a gallery without pictures' do
      let(:record) { Gallery.find_by(title: 'GalleryTwo') }

      context 'as visitor' do
        it { should_fail }
      end

      context 'as admin' do
        let(:current_user) { users(:admin) }
        it { should_pass }
      end
    end

    context 'for a gallery with invisible pictures only' do
      let(:record) { Gallery.find_by(title: 'GalleryThree') }

      context 'as visitor' do
        it { should_fail }
      end

      context 'as admin' do
        let(:current_user) { users(:admin) }
        it { should_pass }
      end

      context 'as uploader' do
        let(:current_user) { users(:sabine) }
        it { should_pass }
      end
    end
  end

  describe 'update?' do
    subject { policy.update? }

    context 'as visitor' do
      it { should_fail }
    end

    context 'as admin' do
      let(:current_user) { users(:admin) }
      it { should_pass }
    end

    context 'as photographer' do
      let(:current_user) { users(:photographer) }
      it { should_pass }
    end

    context 'as leader of related action' do
      let(:current_user) { users(:rolf) }

      it 'is true' do
        expect(record.actions.count).to eq(1)
        expect(current_user).to lead_action(record.actions.first)
        should_pass
      end
    end

    context 'as unrelated user' do
      let(:current_user) { users(:peter) }

      it 'is false' do
        expect(record.actions.count).to eq(1)
        action = record.actions.first
        expect(current_user).not_to lead_action(action)
        expect(current_user).not_to volunteer_in_action(action)
        should_fail
      end
    end

    context 'for a gallery without an action' do
      let(:record) { Gallery.find_by(title: 'No one uses this gallery') }

      context 'as some user' do
        let(:current_user) { users(:rolf) }
        it { should_fail }
      end

      context 'as admin' do
        let(:current_user) { users(:admin) }
        it { should_pass }
      end

      context 'as photographer' do
        let(:current_user) { users(:photographer) }
        it { should_pass }
      end
    end
  end
end
