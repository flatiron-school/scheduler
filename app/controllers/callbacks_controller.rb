class CallbacksController < Devise::OmniauthCallbacksController
  # def github
  #   @user = User.from_omniauth(request.env["omniauth.auth"])
  #   sign_in_and_redirect @user
  # end

  def google_oauth2
    if user = User.find_for_google_oauth2(request.env["omniauth.auth"])
      sign_in user
      redirect_to root_path
    else
      redirect_to new_user_session_path, notice: 'Access Denied. Please make sure you are signing in with your Flatiron gmail account.'
    end
  end
end
