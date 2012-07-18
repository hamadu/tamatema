# encoding: utf-8

class UsersController < ApplicationController
  before_filter :verify_signed_in, only: [:edit, :update, :delete_confirm, :delete]
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find_by_id(params[:id])
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
      @taken = User.find_by_name(newname)
      if @taken
        render 'edit'
      end
      @user.name = newname
    end

    newemail = params[:user][:email]
    if newemail != '' && @user.email != newemail
      @taken = User.find_by_email(newemail)
      if @taken
        render 'edit'
      end
      @user.email = newemail      
    end
    
    
    password = params[:user][:password]
    password_confirmation = params[:user][:password_confirmation]
    if password != '' && password == password_confirmation
      @user.password = password
      @user.password_confirmation = password
    end
    
    if @user.save
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end
  
  def delete_confirm
  end
  
  def delete
  end
  
  private
    def verify_signed_in
      redirect_to login_path unless signed_in?
    end
end
