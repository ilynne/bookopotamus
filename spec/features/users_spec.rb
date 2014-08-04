require 'spec_helper'
# require 'capybara/rspec'
# include ActionController::Base.helpers.number_to_currency

describe 'Users' do

  # let(:admin) { FactoryGirl.create(:user, admin: true) }
  let(:user) { FactoryGirl.build(:user) }

  # before(:each) do
  #   # DatabaseCleaner.clean_with(:truncation)
  # #   visit new_user_session_path
  # #   fill_in "Email", :with => user.email
  # #   fill_in "Password", :with => user.password
  # #   click_button "Sign in"
  #   # @user = FactoryGirl.build(:user)
  # end

  describe 'New signup' do
    describe 'with valid credentials' do
      it 'allows a user to register' do
        visit new_user_registration_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        fill_in 'Password confirmation', with: user.password
        click_button 'Sign up'
        expect(page.body).to include('You are signed in as')
        expect(page.body).to include(user.email)
      end
    end

    describe 'with invalid credentials' do
      it 'password and confirmation mismatch returns error' do
        visit new_user_registration_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        fill_in 'Password confirmation', with: 'hello'
        click_button 'Sign up'
        expect(page.body).to include('Password confirmation doesn&#39;t match')
      end
    end

    describe 'Existing user' do
      before(:all) do
        @user = FactoryGirl.build(:user)
      end

      it 'does not allow a new registration with existing password' do
        @user.save
        visit new_user_registration_path
        fill_in 'Email', with: @user.email
        fill_in 'Password', with: @user.password
        fill_in 'Password confirmation', with: @user.password
        click_button 'Sign up'
        expect(page.body).to include('Email has already been taken')
        expect(page.body).to include(@user.email)
      end

      it 'allows a user to reset the password' do
        visit new_user_password_path
        fill_in 'Email', with: @user.email
        click_button 'Send me reset password instructions'
        expect(page.body).to include('Sign in')
      end
    end

  end
end
