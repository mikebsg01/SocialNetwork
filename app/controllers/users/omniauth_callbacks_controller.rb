class Users::OmniauthCallbacksController < ApplicationController 
  def facebook
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      @user.remember_me = true
      sign_in_and_redirect @user, event: :authentication
    end
  end
end