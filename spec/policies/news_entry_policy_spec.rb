require 'rails_helper'
require 'helpers'

RSpec.describe NewsEntryPolicy do

  include Helpers
  fixtures :users, :news_entries

  let(:current_user) { nil }
  let(:record) { news_entries(:default) }
  let(:policy) { NewsEntryPolicy.new(current_user, record) }

  %w(new? update? edit? destroy? upload_pictures? crop_picture?).each do |method|
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

  describe 'show?' do
    subject { policy.show? }

    context 'for visible news entry' do
      it { should_pass }
    end

    context 'for invisible news entry' do
      before { record.update_attribute :visible, false }
      it { should_fail }

      context 'as user' do
        let(:current_user) { users(:unrelated) }
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

end
