# encoding: utf-8

class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by_name(params[:session][:name])
    if user
      sign_in user
      redirect_to user
    else
      flash[:error] = "メールアドレスまたはパスワードが違います。"
      render 'new'
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
end
