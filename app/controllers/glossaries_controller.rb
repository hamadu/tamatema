# encoding: utf-8

class GlossariesController < ApplicationController
  before_filter :verify_signed_in, only: [:new, :create, :destroy, :update]
  
  def new
    @glossary = Glossary.new
  end
  
  def create
    @glossary = Glossary.new(params[:glossary])
    @glossary.user = current_user
    if @glossary.save
      flash[:success] = "登録完了！"
      redirect_to glossary_path(@glossary.name)
    else
      render 'new'
    end
  end
  
  def destroy
  end
  
  def show
    @glossary = Glossary.find_by_name(params[:name]) || not_found
  end
  
  def edit
    @glossary = Glossary.find_by_name(params[:name]) || not_found
    @glossary_title = @glossary.title
  end
  
  def update
    @glossary = Glossary.find_by_id(params[:glossary][:id]) || not_found
    @glossary_title = @glossary.title
    if @glossary.update_attributes(params[:glossary])
      flash[:success] = "更新完了！"
      redirect_to glossary_path(@glossary.name)
    else
      render 'edit'
    end
  end

  private
    def verify_signed_in
      redirect_to login_path unless signed_in?
    end
end
