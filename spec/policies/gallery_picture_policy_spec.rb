require 'rails_helper'
require 'helpers'

RSpec.describe GalleryPicturePolicy do

  include Helpers
  fixtures :users, :gallery_pictures

  let(:current_user) { nil }
  let(:record) { gallery_pictures(:default_1) }
  let(:policy) { GalleryPicturePolicy.new(current_user, record) }

  %w(create? update? destroy?).each do |method|
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

  %w(edit? make_visible?).each do |method|
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

  describe 'index?' do
    subject { policy.index? }
    it { should_pass }
  end

  describe 'show?' do
    subject { policy.show? }

    context 'for visible picture' do
      it { should_pass }
    end

    context 'for invisible picture' do
      let(:record) { gallery_pictures(:invisible) }

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

      context 'as uploader' do
        let(:current_user) { users(:picture_uploader) }
        it { should_pass }
      end

      context 'as other user' do
        let(:current_user) { users(:unrelated) }
        it { should_fail }
      end
    end
  end

  describe 'make_invisible?' do
    subject { policy.make_invisible? }

    context 'for a visitor' do
      it { should_fail }
    end

    context 'for an admin' do
      let(:current_user) { users(:admin) }
      it { should_pass }
    end

    context 'for an coordinator' do
      let(:current_user) { users(:coordinator) }
      it { should_pass }
    end

    context 'for uploader' do
      let(:current_user) { users(:picture_uploader) }
      it { should_pass }
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

  describe 'is_uploader?' do
    subject { policy.send(:is_uploader?) }

    context 'any user' do
      it { should_fail }
    end

    context 'for an admin' do
      let(:current_user) { users(:admin) }
      it { should_fail }
    end

    context 'for uploader' do
      let(:current_user) { users(:picture_uploader) }
      it { should_pass }
    end
  end
end
