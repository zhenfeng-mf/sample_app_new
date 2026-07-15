class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params) # 実装は終わっていないことに注意!
    if @user.save

      # flash is a Rails built-in helper method that acts like a var.
      # It is a special part of the session.
      # Primary use case of flash: One-time alerts/notices.
      # 1. When flash[:success] = "xxx" executes, Rails saves this into session cookie temporarily.
      # 2. redirect happens, old page dies, new HTTP request loads new page.
      # 3. msg saved in session self wiped when the redirect page finishes rendering.
      #
      # flash is used in many other major actions such as:
      # - Logging out: flash[:info] = "You have logged out." (Redirects to the Home page)
      # - Updating a profile: flash[:success] = "Profile updated!" (Redirects to the Edit page)
      # - Deleting a post: flash[:danger] = "Post deleted." (Redirects to the Index page)
      flash[:success] = 'Welcome to the Sample App!'

      # the same as redirect_to user_url(@user)
      redirect_to @user
    else
      render 'new', status: :unprocessable_entity
    end
  end

  # Every method defined below keyword "private" is a private method.
  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
