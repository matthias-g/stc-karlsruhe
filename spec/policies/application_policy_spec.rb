require 'rails_helper'
require 'helpers'

RSpec.describe ApplicationPolicy do

  include Fixtures

  let(:current_user) { nil }
  let(:record) { nil }
  let(:policy) { ApplicationPolicy.new(current_user, record) }

  describe 'is_admin?' do
    subject { policy.is_admin? }

    it 'is false for no user logged in' do
      expect(subject).to be_falsey
    end

    context 'for an admin' do
      let(:current_user) { users(:admin) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end

    context 'for another user' do
      let(:current_user) { users(:rolf) }

      it 'is false' do
        expect(subject).to be_falsey
      end
    end
  end

  describe 'is_coordinator?' do
    subject { policy.is_coordinator? }

    it 'is false for no user logged in' do
      expect(subject).to be_falsey
    end

    context 'for a coordinator' do
      let(:current_user) { users(:coordinator) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end

    context 'for another user' do
      let(:current_user) { users(:rolf) }

      it 'is false' do
        expect(subject).to be_falsey
      end
    end
  end

  describe 'is_admin_or_coordinator?' do
    subject { policy.is_admin_or_coordinator? }

    it 'is false for no user logged in' do
      expect(subject).to be_falsey
    end

    context 'for an admin' do
      let(:current_user) { users(:admin) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end

    context 'for a coordinator' do
      let(:current_user) { users(:coordinator) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end

    context 'for another user' do
      let(:current_user) { users(:rolf) }

      it 'is false' do
        expect(subject).to be_falsey
      end
    end
  end

  %w(index? new? edit? create? destroy?).each do |method|
    describe method do
      subject { policy.public_send(method) }

      it 'is false' do
        expect(subject).to be(false)
      end
    end
  end

  describe 'show?' do
    subject { policy.show? }

    context 'for existing record' do
      let(:record) { actions('Kostenlose Fahrradreparatur in der Innenstadt') }
      it 'is true' do
        expect(subject).to be_truthy
      end
    end

    context 'for not visible record' do
      let(:record) { actions('Action 2') }
      it 'is false' do
        expect(subject).to be_falsey
      end

      context 'for admin' do
        let(:current_user) { users(:admin) }
        it 'is true' do
          expect(subject).to be_truthy
        end
      end
    end
  end
end
