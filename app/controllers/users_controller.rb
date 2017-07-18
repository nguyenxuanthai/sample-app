class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if user.save
      flash[:success] = t "controllers.users.sample_app"
      redirect_to user
    else
      render :new
    end
  end

  def show
    @user = User.find_by id: params[:id]

    return if user
    flash[:danger] = t "controllers.users.not_found"
    redirect_to root_path
  end

  private

  attr_reader :user

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
