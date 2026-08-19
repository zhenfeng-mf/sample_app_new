class SessionsController < ApplicationController
  def new
    # renders the page containing HTML login form.
  end

  def create
    # Receieves login form, verifies, and starts the session
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      # Success Login
      reset_session
      params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
      log_in(@user)
      redirect_to @user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    # Terminates the session when user logging out.
    
    log_out if logged_in?
    # TURBO REQUIRED: Sends HTTP 303 to force Turbo to switch HTTP verb from DELETE to GET on redirect
    redirect_to root_url, status: :see_other
  end
end
