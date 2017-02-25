require 'rails_helper'
require 'helpers'

RSpec.describe GalleryPolicy do

  include Fixtures

  let(:current_user) { nil }
  let(:record) { Gallery.find_by(title: 'GalleryOne') }
  let(:policy) { GalleryPolicy.new(current_user, record) }

  %w(index? new? edit? create? destroy? make_all_visible? make_all_invisible?).each do |method|
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

    context 'for user leading related project' do
      let(:current_user) { users(:rolf) }

      it 'is true' do
        expect(record.projects.count).to eq(1)
        project = record.projects.first
        project.days << ProjectDay.new(date: 1.days.ago)
        expect(current_user).to lead_project(project)
        expect(subject).to be_truthy
      end
    end

    context 'for an unrelated user to related project' do
      let(:current_user) { users(:peter) }

      it 'is false' do
        expect(record.projects.count).to eq(1)
        project = record.projects.first
        project.days << ProjectDay.new(date: 1.days.ago)
        expect(current_user).not_to lead_project(project)
        expect(current_user).not_to volunteer_in_project(project)
        expect(subject).to be_falsey
      end
    end
  end
end
