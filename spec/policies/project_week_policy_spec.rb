require 'rails_helper'
require 'helpers'

RSpec.describe ProjectWeekPolicy do

  include Fixtures

  let(:current_user) { nil }
  let(:record) { ProjectWeek.find_by(title: '2015')}
  let(:policy) { ProjectWeekPolicy.new(current_user, record) }

  %w(index? create? edit? update? destroy?).each do |method|
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

    it 'is true' do
      expect(subject).to be_truthy
    end
  end
end
