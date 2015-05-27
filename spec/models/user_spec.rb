require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }

  describe 'api_keys' do
    it 'a new user should not have an api_key' do
      expect(user.api_key).to eq(nil)
    end
    it 'should generate an api_key' do
      expect{user.update_api_key}.not_to change{user.api_key}
    end
  end
end