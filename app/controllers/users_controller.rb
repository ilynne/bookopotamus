class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_filter only: [:index, :impersonate] do
    redirect_to :new_user_session unless current_user.try(:admin?)
  end

  def index
    @users = User.all.paginate(:page => params[:page])
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json {}
      end
    end
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

  private

  def set_user
    begin
      @user = User.find(params[:id])
    rescue
      redirect_to root_path
    end
  end

  def user_params
    params[:user].permit(:admin,
                         :restricted)
  end
end
