require 'rails_helper'
require 'helpers'

shared_examples 'a ProjectUserRelationship' do
  include Fixtures

  let(:relationship) { described_class.new(current_user, nil) }

  let(:current_user) { nil }
  let(:user) { users(:birgit) }
  let(:project) { projects('Kostenlose Fahrradreparatur in der Innenstadt') }

  describe 'allow_add_volunteer_to_project?' do
    subject { relationship.allow_add_volunteer_to_project?(user, project) }

    it 'should be false for no user logged in' do
      expect(subject).to be_falsey
    end

    context 'user adds themselves' do
      let(:current_user) { users(:birgit) }

      it 'is true' do
        expect(subject).to be_truthy
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

      context 'project is closed' do
        let(:project) { projects('Geschlossene Aktion') }

        it 'is false' do
          expect(subject).to be_falsey
        end
      end

      context 'project is full' do
        let(:project) { projects('Volle Aktion') }

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

  describe 'allow_remove_volunteer_from_project?' do
    subject { relationship.allow_remove_volunteer_from_project?(user, project) }
    let(:user) { users(:sabine) }

    it 'should be false for no user logged in' do
      expect(subject).to be_falsey
    end

    context 'user removes themselves' do
      let(:current_user) { users(:sabine) }

      it 'is true' do
        expect(subject).to be_truthy
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

      context 'project is closed' do
        let(:project) { projects('Fast volle, geschlossene Aktion') }

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
end

describe UserPolicy do
  it_behaves_like 'a ProjectUserRelationship'
end

describe ProjectPolicy do
  it_behaves_like 'a ProjectUserRelationship'
end