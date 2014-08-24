class UsersController < ApplicationController
  before_filter only: [:index, :impersonate] do
    redirect_to :new_user_session unless current_user.try(:admin?)
  end

  def index
    @users = User.all.paginate(:page => params[:page])
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

end
