# encoding: utf-8

class StaticPagesController < ApplicationController
  def home
    redirect_to user_path(current_user) if current_user != nil
  end

  def help
  end

  def about
  end
end
