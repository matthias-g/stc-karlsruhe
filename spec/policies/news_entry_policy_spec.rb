require 'rails_helper'
require 'helpers'

RSpec.describe NewsEntryPolicy do

  include Fixtures

  let(:current_user) { nil }
  let(:record) { NewsEntry.find_by(title: 'Online') }
  let(:policy) { NewsEntryPolicy.new(current_user, record) }

  %w(new? update? edit? destroy? upload_pictures? crop_picture?).each do |method|
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

    it 'is true for visible entry' do
      expect(subject).to be_truthy
    end

    context 'for invisible entry' do
      let(:record) { NewsEntry.find_by(title: 'Invisible') }

      it 'is false' do
        expect(subject).to be_falsey
      end

      context 'for an admin' do
        let(:current_user) { users(:admin) }

        it 'is true' do
          expect(subject).to be_truthy
        end
      end
    end
  end
end
