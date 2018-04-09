class SessionsController < ApplicationController
  before_action :set_user, only: :create
  def new; end

  def create
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      check_remember
      redirect_to @user
    else
      flash.now[:danger] = I18n.t "flash.session_danger"
      render "new"
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def set_user
    @user = User.find_by email: params[:session][:email].downcase
  end

  def check_remember
    if params[:session][:remember_me] == Settings.users.is_remember
      remember @user
    else
      forget @user
    end
  end
end
