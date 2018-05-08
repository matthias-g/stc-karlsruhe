require 'rails_helper'
require 'helpers'

shared_examples 'a EventUserRelationship' do
  include Fixtures

  let(:relationship) { described_class.new(current_user, nil) }

  let(:current_user) { nil }
  let(:user) { users(:birgit) }
  let(:action) { actions('Kostenlose Fahrradreparatur in der Innenstadt') }

  describe 'allow_add_volunteer_to_event?' do
    subject { relationship.allow_add_volunteer_to_event?(user, action.events.first) }

    it 'should be false for no user logged in' do
      expect(subject).to be_falsey
    end

    context 'user adds themselves' do
      let(:current_user) { users(:birgit) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end

    context 'leader is logged in' do
      let(:current_user) { users(:rolf) }

      it 'is true' do
        expect(subject).to be_truthy
      end

      context 'action is finished' do
        before { action.events.first.update_attribute :date, Date.yesterday }

        it 'is false' do
          expect(subject).to be_falsey
        end
      end
    end

    context 'admin is logged in' do
      let(:current_user) { users(:admin) }

      it 'is true' do
        expect(subject).to be_truthy
      end

      context 'user is already volunteer' do
        let(:user) { users(:sabine) }

        it 'is false' do
          expect(subject).to be_falsey
        end
      end

      context 'action is finished' do
        let(:action) { actions('Beendete Aktion') }

        it 'is true' do
          expect(subject).to be_truthy
        end
      end

      context 'action is full' do
        let(:action) { actions('Volle Aktion') }

        it 'is false' do
          expect(subject).to be_falsey
        end
      end
    end

    context 'coordinator is logged in' do
      let(:current_user) { users(:coordinator) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end
  end

  describe 'allow_remove_volunteer_from_event?' do
    subject { relationship.allow_remove_volunteer_from_event?(user, action.events.first) }
    let(:user) { users(:sabine) }

    it 'should be false for no user logged in' do
      expect(subject).to be_falsey
    end

    context 'user removes themselves' do
      let(:current_user) { users(:sabine) }

      it 'is true' do
        expect(subject).to be_truthy
      end

      context 'action is finished' do
        let(:action) { actions('Fast volle, beendete Aktion') }

        it 'is false' do
          expect(subject).to be_falsey
        end
      end
    end

    context 'other user is logged in' do
      let(:current_user) { users(:peter) }

      it 'is false' do
        expect(subject).to be_falsey
      end
    end

    context 'admin is logged in' do
      let(:current_user) { users(:admin) }

      it 'is true' do
        expect(subject).to be_truthy
      end

      context 'user is not a volunteer' do
        let(:user) { users(:birgit) }

        it 'is false' do
          expect(subject).to be_falsey
        end
      end

      context 'action is finished' do
        let(:action) { actions('Fast volle, beendete Aktion') }

        it 'is true' do
          expect(subject).to be_truthy
        end
      end
    end

    context 'coordinator is logged in' do
      let(:current_user) { users(:coordinator) }

      it 'is true' do
        expect(subject).to be_truthy
      end
    end
  end
end

describe UserPolicy do
  it_behaves_like 'a EventUserRelationship'
end

describe EventPolicy do
  it_behaves_like 'a EventUserRelationship'
end