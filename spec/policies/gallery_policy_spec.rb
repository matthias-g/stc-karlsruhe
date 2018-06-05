require 'rails_helper'
require 'helpers'

RSpec.describe GalleryPolicy do

  include Helpers
  fixtures :users, :galleries

  let(:current_user) { nil }
  let(:record) { galleries(:default) }
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
      let(:record) { galleries(:empty_gallery) }

      context 'as visitor' do
        it { should_fail }
      end

      context 'as admin' do
        let(:current_user) { users(:admin) }
        it { should_pass }
      end
    end

    context 'for a gallery with invisible pictures only' do
      let(:record) { galleries(:invisible_gallery) }

      context 'as visitor' do
        it { should_fail }
      end

      context 'as admin' do
        let(:current_user) { users(:admin) }
        it { should_pass }
      end

      context 'as uploader' do
        let(:current_user) { users(:picture_uploader) }
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
      let(:current_user) { users(:leader) }

      it 'is true' do
        expect(record.owner).not_to eq(nil)
        expect(current_user).to lead_action(record.owner)
        should_pass
      end
    end

    context 'as unrelated user' do
      let(:current_user) { users(:unrelated) }

      it 'is false' do
        expect(record.owner).not_to eq(nil)
        initiative = record.owner
        expect(current_user).not_to lead_action(initiative)
        expect(current_user).not_to volunteer_in_action(initiative)
        should_fail
      end
    end

    context 'for a news entry gallery' do
      let(:record) { galleries(:news_entry_gallery) }

      context 'as some user' do
        let(:current_user) { users(:volunteer) }
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
