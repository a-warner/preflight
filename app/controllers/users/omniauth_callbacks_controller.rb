class Users::OmniauthCallbacksController < ApplicationController
  def github
    if user_signed_in?
      current_user.update_from_omniauth!(omniauth)
      redirect_to :root, :notice => "Done!"
    else
      user = User.find_or_create_from_omniauth!(omniauth)

      flash[:notice] = after_sign_in_notice_for(user)
      sign_in_and_redirect(user)
    end
  end

  private

  def omniauth
    request.env['omniauth.auth']
  end

  def after_sign_in_notice_for(user)
    if user.just_created?
      "Signed up with github!"
    else
      "Logged in with github"
    end
  end
end
