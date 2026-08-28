class UsersController < ApplicationController
  
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  # Display user sign up page.
  def new
    @user = User.new
  end

  # Listing all users
  def index 
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return if !@user.activated?
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # UserMailer.account_activation(@user).deliver_now
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
      # forwarding_url = session[:forwarding_url]
      # reset_session
      # log_in @user
      
      # # flash is a Rails built-in helper method that acts like a var.
      # # It is a special part of the session.
      # # Primary use case of flash: One-time alerts/notices.
      # # 1. When flash[:success] = "xxx" executes, Rails saves this into session cookie temporarily.
      # # 2. redirect happens, old page dies, new HTTP request loads new page.
      # # 3. msg saved in session self wiped when the "REDIRECT" page finishes rendering.
      # # flash.now expects a RENDER while flash expects a REDIRECT.
      # #
      # # flash is used in many other major actions such as:
      # # - Logging out: flash[:info] = "You have logged out." (Redirects to the Home page)
      # # - Updating a profile: flash[:success] = "Profile updated!" (Redirects to the Edit page)
      # # - Deleting a post: flash[:danger] = "Post deleted." (Redirects to the Index page)
      # flash[:success] = 'Welcome to the Sample App!'

      # # the same as redirect_to user_url(@user)
      # redirect_to forwarding_url || @user
    else
      render 'new', status: :unprocessable_entity
    end
  end

  # Display user edit page.
  def edit 
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      # Update flash message and redirect to user page when success
      flash[:success] = "Profile Updated"
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url, status: :see_other
  end

  # Every method defined below keyword "private" is a private method.
  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) if !current_user?(@user)
  end

  def admin_user
    redirect_to(root_url, status: :see_other) unless current_user.admin?
  end

end


