require 'rails_helper'
require 'helpers'

RSpec.describe OrgaMessagePolicy do

  include Helpers
  fixtures :users, :orga_messages

  let(:current_user) { nil }
  let(:record) { orga_messages(:default) }
  let(:policy) { OrgaMessagePolicy.new(current_user, record) }

  %w(index? new? create? edit?).each do |method|
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

  %w(update? send_message?).each do |method|
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

      context 'for already sent message' do
        let(:record) { orga_messages(:already_sent) }
        it { should_fail }

        context 'as admin' do
          let(:current_user) { users(:admin) }
          it { should_fail }
        end
      end
    end
  end

  describe 'destroy?' do
    subject { policy.destroy? }

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

    context 'for already sent message' do
      let(:record) { orga_messages(:already_sent) }
      it { should_fail }

      context 'as coordinator' do
        let(:current_user) { users(:coordinator) }
        it { should_fail }
      end

      context 'as admin' do
        let(:current_user) { users(:admin) }
        it { should_pass }
      end
    end
  end

end
