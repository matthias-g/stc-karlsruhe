require 'rails_helper'
require 'helpers'

RSpec.describe OrgaMessagePolicy do

  include Fixtures

  let(:current_user) { nil }
  let(:record) { OrgaMessage.find_by(subject: 'Neue Aktionswoche') }
  let(:policy) { OrgaMessagePolicy.new(current_user, record) }

  %w(index? new? create? edit?).each do |method|
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

  %w(update? destroy? send_message?).each do |method|
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

      context 'admin logged in and message is sent' do
        let(:current_user) { users(:admin) }
        let(:record) { OrgaMessage.find_by(subject: 'Sent message') }

        it 'is false' do
          expect(subject).to be_falsey
        end
      end
    end
  end
end
