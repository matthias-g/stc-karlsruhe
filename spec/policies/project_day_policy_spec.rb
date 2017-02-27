require 'rails_helper'
require 'helpers'

RSpec.describe ProjectDayPolicy do

  include Fixtures

  let(:current_user) { nil }
  let(:record) { ProjectDay.find_by(title: '2015-05-07') }
  let(:policy) { ProjectDayPolicy.new(current_user, record) }

  %w(show? index?).each do |method|
    describe method do
      subject { policy.public_send(method) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end
  end

  %w(create? edit? update? destroy?).each do |method|
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

end
