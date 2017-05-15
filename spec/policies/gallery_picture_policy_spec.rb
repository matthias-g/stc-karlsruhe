require 'rails_helper'
require 'helpers'

RSpec.describe GalleryPicturePolicy do

  include Fixtures

  let(:current_user) { nil }
  let(:record) { GalleryPicture.find_by(picture: 'VisiblePicture') }
  let(:policy) { GalleryPicturePolicy.new(current_user, record) }

  %w(create? update? destroy?).each do |method|
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

  %w(edit? make_visible?).each do |method|
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

  describe 'index?' do
    subject { policy.index? }

    it 'is true' do
      expect(subject).to be_truthy
    end
  end

  describe 'show?' do
    subject { policy.show? }

    it 'is true for visible picture' do
      expect(subject).to be_truthy
    end

    context 'for invisible picture' do
      let(:record) { GalleryPicture.find_by(picture: 'InvisiblePicture') }

      it 'is false' do
        expect(subject).to be_falsey
      end

      context 'for an admin' do
        let(:current_user) { users(:admin) }

        it 'is true' do
          expect(subject).to be_truthy
        end
      end

      context 'for an coordinator' do
        let(:current_user) { users(:coordinator) }

        it 'is true' do
          expect(subject).to be_truthy
        end
      end

      context 'for uploader' do
        let(:current_user) { record.uploader }

        it 'is true' do
          expect(subject).to be_truthy
        end
      end

      context 'for other user' do
        let(:current_user) { users(:peter) }

        it 'is false' do
          expect(subject).to be_falsey
        end
      end
    end
  end

  describe 'make_invisible?' do
    subject { policy.make_invisible? }

    it 'is false when no user logged in' do
      expect(subject).to be_falsey
    end

    context 'for an admin' do
      let(:current_user) { users(:admin) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end
    context 'for an coordinator' do
      let(:current_user) { users(:coordinator) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end

    context 'for uploader' do
      let(:current_user) { users(:sabine) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end
  end

  describe 'permitted_attributes_for_show' do
    subject { policy.permitted_attributes_for_show }

    it 'contains only public attributes for no user logged in' do
      expect(subject).to contain_exactly(:width, :height, :desktop_width, :desktop_height, :picture, :editable)
    end

    context 'admin logged in' do
      let(:current_user) { users(:admin) }

      it 'contains other attributes' do
        expect(subject).to contain_exactly(:width, :height, :desktop_width, :desktop_height, :picture, :editable, :visible, :uploader)
      end
    end
  end
end
