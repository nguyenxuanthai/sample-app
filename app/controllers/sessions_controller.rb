class SessionsController < ApplicationController
  def create
    session = params[:session]
    user = User.find_by email: session[:email].downcase

    if user && user.authenticate(session[:password])
      login_success user
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
    if user.activated?
      log_in user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      redirect_back_or user
    else
      message = t "app.controllers.sessions.login_fails"
      flash[:warning] = message
      redirect_to root_url
    end
  end

  def login_fail
    flash[:danger] = t "invalid_email"
    render :new
  end
end
