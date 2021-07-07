class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(show new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy
  before_action :find_user, except: %i(index new create)

  def index
    @users = User.paginate page: params[:page]
  end

  def show
    return if @user
    flash[:danger] = t "error.signup"
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "flash.create_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "flash.update_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t ".delete_success"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "flash.login_danger"
    redirect_to login_url
  end

  def correct_user
    find_user
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def find_user
    @user = User.find_by params[:id]
    redirect_to root_url unless exists_user? @user
  end
end
