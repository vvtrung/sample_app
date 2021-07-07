class SessionsController < ApplicationController
  before_action :set_user, only: :create

  def new; end

  def create
    if @user && @user.authenticate(params[:session][:password])
      activated_user
    else
      flash.now[:danger] = I18n.t "flash.session_danger"
      render :new
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

  def activated_user
    if @user.activated?
      log_in @user
      remember_user
      redirect_back_or @user
    else
      flash[:warning] = I18n.t "flash.session_warning"
      redirect_to root_url
    end
  end

  def remember_user
    if params[:session][:remember_me] == Settings.users.is_remember
      remember @user
    else
      forget @user
    end
  end
end
