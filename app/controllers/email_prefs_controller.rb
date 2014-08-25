class EmailPrefsController < ApplicationController
  before_action :set_user, only: [:show]

  def update
    @email_prefs = EmailPrefs.find(params[:id])
    if @email_prefs.update(email_prefs_params)
      redirect_to email_pref_path, notice: 'User email preferences changed.'
    else
      redirect_to email_pref_path, error: 'Something went wrong.'
    end
  end

  def show
    @email_prefs = EmailPrefs.find_or_create_by(user: current_user)
  end

  private

  def set_user
    begin
      @user = current_user
    rescue
      redirect_to root_path
    end
  end

  def email_prefs_params
    params[:email_prefs].permit(:user_id, :all_ratings, :all_reviews, :digest, :opt_out)
  end
end
