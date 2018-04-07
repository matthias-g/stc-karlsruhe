require 'rails_helper'
require 'helpers'

RSpec.describe GalleryPolicy do

  include Fixtures

  let(:current_user) { nil }
  let(:record) { Gallery.find_by(title: 'GalleryOne') }
  let(:policy) { GalleryPolicy.new(current_user, record) }

  %w(index? new? create? destroy?).each do |method|
    describe method do
      subject { policy.public_send(method) }

      it 'is false for no user logged in' do
        expect(subject).to be_falsey
      end

      context 'admin logged in' do
        let(:current_user) { users(:admin) }

        it 'is true' do
          expect(subject).to be_truthy
        end
      end
    end
  end

  %w(edit? make_all_visible? make_all_invisible?).each do |method|
    describe method do
      subject { policy.public_send(method) }

      it 'is false for no user logged in' do
        expect(subject).to be_falsey
      end

      context 'admin logged in' do
        let(:current_user) { users(:admin) }

        it 'is true' do
          expect(subject).to be_truthy
        end
      end

      context 'coordinator logged in' do
        let(:current_user) { users(:coordinator) }

        it 'is true' do
          expect(subject).to be_truthy
        end
      end
    end
  end

  describe 'show?' do
    subject { policy.show? }

    it 'is true for no user logged in' do
      expect(subject).to be_truthy
    end

    context 'gallery without pictures' do
      let(:record) { Gallery.find_by(title: 'GalleryTwo') }

      it 'is false for no user logged in' do
        expect(subject).to be_falsey
      end

      context 'admin logged in' do
        let(:current_user) { users(:admin) }

        it 'is true' do
          expect(subject).to be_truthy
        end
      end
    end

    context 'gallery with invisible pictures only' do
      let(:record) { Gallery.find_by(title: 'GalleryThree') }

      it 'is false for no user logged in' do
        expect(subject).to be_falsey
      end

      context 'when admin logged in' do
        let(:current_user) { users(:admin) }

        it 'is true' do
          expect(subject).to be_truthy
        end
      end

      context 'when uploader of gallery pictures logged in' do
        let(:current_user) { users(:sabine) }

        it 'is true' do
          expect(subject).to be_truthy
        end
      end
    end
  end

  describe 'update?' do
    subject { policy.update? }

    it 'is false for no user logged in' do
      expect(subject).to be(false)
    end

    context 'for an admin' do
      let(:current_user) { users(:admin) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end

    context 'for a photographer' do
      let(:current_user) { users(:photographer) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end

    context 'for user leading related action' do
      let(:current_user) { users(:rolf) }

      it 'is true' do
        expect(record.actions.count).to eq(1)
        action = record.actions.first
        expect(current_user).to lead_action(action)
        expect(subject).to be_truthy
      end
    end

    context 'for an unrelated user to related action' do
      let(:current_user) { users(:peter) }

      it 'is false' do
        expect(record.actions.count).to eq(1)
        action = record.actions.first
        expect(current_user).not_to lead_action(action)
        expect(current_user).not_to volunteer_in_action(action)
        expect(subject).to be_falsey
      end
    end

    context 'for a gallery without an action' do
      let(:record) { Gallery.find_by(title: 'No one uses this gallery') }

      context 'for some user' do
        let(:current_user) { users(:rolf) }

        it 'is false' do
          expect(subject).to eql(false)
        end
      end

      context 'for an admin' do
        let(:current_user) { users(:admin) }

        it 'is true' do
          expect(subject).to be_truthy
        end
      end

      context 'for a photographer' do
        let(:current_user) { users(:photographer) }

        it 'is true' do
          expect(subject).to be_truthy
        end
      end
    end
  end
end
