require 'spec_helper'

describe UsersController do

  DatabaseCleaner.clean_with(:truncation)
  # login_admin
  let(:admin) { FactoryGirl.create(:admin) }
  # let(:user) { FactoryGirl.create(:user) }
  login_admin
  let(:valid_attributes) { { :email => admin.email, :password => admin.password, :password_confirmation => admin.password_confirmation, :admin => true } }
  let(:invalid_attributes) { { :email => '', :password => 'hello', :password_confirmation => 'goodbye', :admin => true } }

  # describe "GET index" do
  #   it "assigns all users as @users" do
  #     user = User.create! valid_attributes
  #     get :index, {}, valid_session
  #     assigns(:users).should eq([user])
  #   end
  # end

  # describe "GET show" do
  #   it "assigns the requested user as @user" do
  #     user = User.create! valid_attributes
  #     get :show, {:id => user.to_param}, valid_session
  #     assigns(:user).should eq(user)
  #   end
  # end

  # describe "GET new" do
  #   it "assigns a new user as @user" do
  #     get :new, {}, valid_session
  #     assigns(:user).should be_a_new(User)
  #   end
  # end

  # describe "GET edit" do
  #   it "assigns the requested user as @user" do
  #     user = User.create! valid_attributes
  #     get :edit, {:id => user.to_param}, valid_session
  #     assigns(:user).should eq(user)
  #   end
  # end

  describe "POST create" do
    describe "with valid params" do
      render_views
      it "creates a new Admin" do
        expect {
          post :create, {:user => valid_attributes}
        }.to change(User, :count).by(1)
      end
    end

    describe "with invalid params" do
      it "does not create a new Admin" do
        expect {
          post :create, {:user => invalid_attributes}
        }.to_not change(User, :count)
      end
    end

  #     it "assigns a newly created user as @user" do
  #       post :create, {:user => valid_attributes}, valid_session
  #       assigns(:user).should be_a(User)
  #       assigns(:user).should be_persisted
  #     end

  #     it "redirects to the created user" do
  #       post :create, {:user => valid_attributes}, valid_session
  #       response.should redirect_to(User.last)
  #     end
  #   end

  #   describe "with invalid params" do
  #     it "assigns a newly created but unsaved user as @user" do
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       User.any_instance.stub(:save).and_return(false)
  #       post :create, {:user => {  }}, valid_session
  #       assigns(:user).should be_a_new(User)
  #     end

  #     it "re-renders the 'new' template" do
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       User.any_instance.stub(:save).and_return(false)
  #       post :create, {:user => {  }}, valid_session
  #       response.should render_template("new")
  #     end
  #   end
  end

  describe "Patch update" do
    describe "with valid params" do
      it "updates the requested user" do
        user = FactoryGirl.create(:user)
        user.save
        patch :update, :id => user.id, :user => { :restricted => 1 }
        user.reload
        expect(user.restricted).to eq(true)
      end

  #     it "assigns the requested user as @user" do
  #       user = User.create! valid_attributes
  #       put :update, {:id => user.to_param, :user => valid_attributes}, valid_session
  #       assigns(:user).should eq(user)
  #     end

  #     it "redirects to the user" do
  #       user = User.create! valid_attributes
  #       put :update, {:id => user.to_param, :user => valid_attributes}, valid_session
  #       response.should redirect_to(user)
  #     end
    end

    describe "with invalid params" do
      it 'does not update the user' do
        user = FactoryGirl.create(:user)
        user.save
        patch :update, :id => user.id, :user => { :email => admin.email }
        user.reload
        expect(user.restricted).to eq(false)
      end
      it 'redirects if the userid is not found' do
        patch :update, :id => User.last.id + 1, :user => { :restricted => true }
      end
    end

  #   describe "with invalid params" do
  #     it "assigns the user as @user" do
  #       user = User.create! valid_attributes
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       User.any_instance.stub(:save).and_return(false)
  #       put :update, {:id => user.to_param, :user => {  }}, valid_session
  #       assigns(:user).should eq(user)
  #     end

  #     it "re-renders the 'edit' template" do
  #       user = User.create! valid_attributes
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       User.any_instance.stub(:save).and_return(false)
  #       put :update, {:id => user.to_param, :user => {  }}, valid_session
  #       response.should render_template("edit")
  #     end
  #   end
  end

  # describe "DELETE destroy" do
  #   it "destroys the requested user" do
  #     user = User.create! valid_attributes
  #     expect {
  #       delete :destroy, {:id => user.to_param}, valid_session
  #     }.to change(User, :count).by(-1)
  #   end

  #   it "redirects to the users list" do
  #     user = User.create! valid_attributes
  #     delete :destroy, {:id => user.to_param}, valid_session
  #     response.should redirect_to(users_url)
  #   end
  # end

end
