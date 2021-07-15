class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end

  def edit
    @user = User.find_by(email: params[:email])
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email])
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "An email was just sent to you for reseting your password."
      debugger
      redirect_to root_url
    else
      flash.now[:danger] = "Email is not available"
      render 'new'
    end
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "Can't be empty")
      render 'edit'
    elsif @user.update(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
    def get_user
      # @user = User.find_by(email: params[:email])
      return false
    end

    def valid_user
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
