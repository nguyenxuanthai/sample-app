class SessionsController < ApplicationController
  def create
    session = params[:session]
    user = User.find_by email: session[:email].downcase

    if user && user.authenticate(session[:password])
      login_success user
      redirect_back_or user
    else
      login_fail
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private
  def login_success user
    log_in user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
  end

  def login_fail
    flash[:danger] = t "invalid_email"
    render :new
  end
end
