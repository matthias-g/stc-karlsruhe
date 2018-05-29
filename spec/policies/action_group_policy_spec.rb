require 'rails_helper'
require 'helpers'

RSpec.describe ActionGroupPolicy do

  include Helpers
  fixtures :action_groups, :users

  let(:current_user) { nil }
  let(:record) { action_groups(:default) }
  let(:policy) { ActionGroupPolicy.new(current_user, record) }

  %w(index? create? edit? update? destroy?).each do |method|
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

  describe 'show?' do
    subject { policy.show? }
    it { should_pass }
  end

end
