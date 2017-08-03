class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create show)
  before_action :find_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if user.save
      user.send_activation_email
      flash[:info] = t "controllers.users.activate_email"
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    if user
      @microposts = user.microposts.order_desc.paginate page: params[:page]
      render locals: {
        relationship_build: relationship_build,
        relationship_destroy: relationship_destroy
      }
    else
      flash[:danger] = t "controllers.users.url_invaild"
      redirect_to root_url
    end
  end

  def edit; end

  def update
    if user.update_attributes user_params
      flash[:success] = t "controllers.users.profile_updated"
      redirect_to user
    else
      render :edit
    end
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "controllers.users.please_log_in"
    redirect_to login_url
  end

  def destroy
    user.destroy
    flash[:success] = t "controllers.users.user_deleted"
    redirect_to users_url
  end

  def find_user
    @user = User.find_by id: params[:id]

    return if user
    flash[:danger] = t "controllers.users.not_found"
    redirect_to root_path
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  private

  attr_reader :user

  def relationship_destroy
    current_user.active_relationships.find_by followed_id: user.id
  end

  def relationship_build
    current_user.active_relationships.build
  end

  def correct_user
    redirect_to root_url unless user.current_user? current_user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
