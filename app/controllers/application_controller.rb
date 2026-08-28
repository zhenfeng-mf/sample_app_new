class ApplicationController < ActionController::Base
  include SessionsHelper

  private
    def logged_in_user
      if !logged_in?
        store_location
        flash[:danger] = "Please Log In"
        redirect_to(login_path, status: :see_other)
      end
    end
end
