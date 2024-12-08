# app/controllers/users_controller.rb
class UsersController < ApplicationController
  def index
    @users = User.order(:username)
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :private, :password, :password_confirmation, :current_password)
  end
end
