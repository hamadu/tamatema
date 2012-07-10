# encoding: utf-8

class SessionsController < ApplicationController
  def new
    
  end
  
  def create
    user = User.find_by_email(params[:session][:email])
    if user and user.authenticate(params[:session][:password])
      redirect_to user
    else
      flash[:error] = "メールアドレスまたはパスワードが違います。"
      render 'new'
    end
  end
  
  def destroy
  end
end