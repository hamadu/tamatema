# encoding: utf-8

class AuthController < ApplicationController
  def callback
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    sign_in user
    redirect_to root_url, :notice => "ログインしました。"
  end
end
