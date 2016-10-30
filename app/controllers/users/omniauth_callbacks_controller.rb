class Users::OmniauthCallbacksController < ApplicationController 
  def facebook
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      @user.remember_me = true
      sign_in_and_redirect @user, event: :authentication
    else
      session['omniauth.auth'] = request.env['omniauth.auth']
      render :edit
    end
  end

  def custom_sign_up
    @user = User.from_omniauth(session['omniauth.auth'])

    if @user.update(user_params)
      sign_in_and_redirect @user, event: :authentication
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :username, :email)
  end
end