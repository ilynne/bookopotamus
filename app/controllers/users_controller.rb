class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter only: [:index, :impersonate] do
    redirect_to root_path unless current_user.try(:admin?)
  end
  before_action :check_email, only: [:invite]

  def index
    @users = User.all.paginate(:page => params[:page])
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: 'User privileges changed.' }
        format.json { render :show, status: :ok }
      else
        format.html { redirect_to users_path, error: 'That update was declined.' }
        format.json {}
      end
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'Success!'
      flash[:notice] = 'Admin was added.'
      Notification.welcome_email(@user).deliver
    else
      flash[:error] = 'There was a problem creating the admin.'
    end
    # flash.keep
    redirect_to root_path
  end

  def impersonate
    user = User.find(params[:user][:id])
    impersonate_user(user)
    redirect_to root_path
  end

  def stop_impersonating
    stop_impersonating_user
    redirect_to root_path
  end

  def invite
    options = { email: params[:user][:email], from: current_user.email, admin: false }
    if params[:user][:admin].present? && params[:user][:admin] == '1'
      options[:admin] = true
    end
    Notification.member_invite(options).deliver
    flash[:success] = 'Member invited!'
    redirect_to root_path
  end

  private

  def check_email
    if params[:user][:email].blank?
      redirect_to root_path, notice: 'You must enter an email address.'
    end
  end
    
  def set_user
    begin
      @user = User.find(params[:id])
    rescue
      redirect_to root_path
    end
  end

  def user_params
    params[:user].permit(:email,
                         :password,
                         :password_confirmation,
                         :admin,
                         :restricted)
  end
end
