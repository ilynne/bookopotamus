require 'spec_helper'
# require 'capybara/rspec'
# include ActionController::Base.helpers.number_to_currency

describe 'Users' do

  # let(:admin) { FactoryGirl.create(:user, admin: true) }
  let(:new_user) { FactoryGirl.build(:user) }
  let(:user) { FactoryGirl.create(:user) }
  let(:admin) { FactoryGirl.create(:admin) }

  describe 'New signup' do
    describe 'with valid credentials' do
      it 'allows a user to register' do
        visit new_user_registration_path
        within('div#new_user_form') do
          fill_in 'Email', with: new_user.email
          fill_in 'Password', with: new_user.password
          fill_in 'Password confirmation', with: new_user.password
          click_button 'Sign up'
        end
        # expect(page.body).to include('You are signed in as')
        expect(page.body).to include(new_user.email)
      end
    end

    describe 'with invalid credentials' do
      it 'password and confirmation mismatch returns error' do
        visit new_user_registration_path
        within('div#new_user_form') do
          fill_in 'Email', with: user.email
          fill_in 'Password', with: user.password
          fill_in 'Password confirmation', with: 'hello'
          click_button 'Sign up'
        end
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
        within('div#new_user_form') do
          fill_in 'Email', with: @user.email
          fill_in 'Password', with: @user.password
          fill_in 'Password confirmation', with: @user.password
          click_button 'Sign up'
        end
        expect(page.body).to include('Email has already been taken')
        expect(page.body).to include(@user.email)
      end

      it 'allows a user to reset the password' do
        visit new_user_password_path
        within('div#forgot_password_form') do
          fill_in 'Email', with: @user.email
          click_button 'Send me reset password instructions'
        end
        expect(page.body).to include('Sign in')
      end
    end

    describe 'Admin' do
      describe 'as an admin' do
        before(:each) do
          visit new_user_session_path
          within('div.sidebar-login') do
            fill_in 'Email', with: admin.email
            fill_in 'Password', with: admin.password
            click_button 'Sign in'
          end
        end

        it 'allows the admin to impersonate a user' do
          non_admin = FactoryGirl.create(:user)
          visit root_path
          select non_admin.email, :from => 'user_id'
          click_button 'Impersonate'
          expect(page.body).to include('are signed in as')
        end

        it 'allows the admin to stop impersonating a user' do
          non_admin = FactoryGirl.create(:user)
          visit root_path
          select non_admin.email, :from => 'user_id'
          click_button 'Impersonate'
          click_link 'Back to admin'
          expect(page.body).to_not include('are signed in as')
        end

        it 'lists the users' do
          visit users_path
          expect(page.body).to include(User.all.count.to_s)
        end

        it 'indicates that the user is an admin' do
          visit root_path
          expect(page.body).to include('[admin]')
        end

        it 'allows the admin to add an admin' do
          visit root_path
          fill_in 'user_email', with: 'newadmin@example.com'
          fill_in 'user_password', with: 'OpenSesame'
          fill_in 'user_password_confirmation', with: 'OpenSesame'
          check 'user_admin'
          click_button 'Add'
          expect(page.body).to include('Admin was added')
        end

        it 'does not add an admin with invalid credentials' do
          visit root_path
          fill_in 'user_email', with: 'newadmin@example.com'
          fill_in 'user_password', with: 'OpenSesame'
          fill_in 'user_password_confirmation', with: ''
          check 'user_admin'
          click_button 'Add'
          expect(page.body).to include('There was a problem')
        end

        it 'allows an admin to invite an admin' do
          visit root_path
          fill_in 'invite_email', with: 'newadmin@example.com'
          check 'invite_admin'
          click_button 'Invite'
          expect(page.body).to include('Member invited')
        end
        it 'fails if no email is provided' do
          visit root_path
          fill_in 'invite_email', with: ''
          click_button 'Invite'
          expect(page.body).to include('You must enter an email')
        end
      end
      describe 'as a non admin' do
        before(:each) do
          visit root_path
          within('div.sidebar-login') do
            fill_in 'Email', with: user.email
            fill_in 'Password', with: user.password
          end
          click_button 'Sign in'
        end
        it 'should not show a user the users' do
          visit users_path
          expect(page.body).to_not include('Users')
        end
      end
    end
  end
end
