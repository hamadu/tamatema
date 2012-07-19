# encoding: utf-8

class UsersController < ApplicationController
  before_filter :verify_signed_in, only: [:edit, :update, :delete_confirm, :delete]
  
  def show
    @user = User.find_by_id(params[:id]) || not_found
    @isself = (@user == current_user)
  end
  
  def edit
    @user = current_user
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "登録完了！"
      sign_in @user
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def update
    @user = current_user
    newname = params[:user][:name]
    if newname != '' && @user.name != newname
      @user.name = newname
    end
    
    if @user.save
      sign_in @user
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end
  
  def delete_confirm
    @user = current_user
  end
  
  def delete
    if current_user.destroy then
      flash[:success] = "データを削除しました。ご利用ありがとうございました。"
      redirect_to root_path
    else
      render 'delete_confirm'
    end
  end
  
  private
    def verify_signed_in
      redirect_to login_path unless signed_in?
    end
end
