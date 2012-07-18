class WordsController < ApplicationController
  before_filter :verify_signed_in
  before_filter :verify_glossary, only: [:new, :edit]
  
  def new
    render :layout => 'ajax'
  end
  
  def create
    @word = Word.new(params[:word])
    glossary = Glossary.find_by_name(params[:name])
    if glossary and glossary.user_id == current_user.id
      @word.glossary = glossary
      if @word.save
        status = 'success'
      else
        status = 'failure'
      end
    else
      status = 'failure'
    end
    render json: { status: status, data: @word, error: @word.errors.full_messages }
  end
  
  def edit
    @word = Word.find_by_id(params[:id]) || not_found    
    render :layout => 'ajax'
  end
  
  def update
    @word = Word.find_by_id(params[:id]) || not_found
    @word.name = params[:word][:name]
    @word.description = params[:word][:description]
    @word.read = params[:word][:read]
    glossary = Glossary.find_by_name(params[:name])
    if glossary and glossary.user_id == current_user.id and @word.glossary == glossary
      @word.glossary = glossary
      if @word.save
        status = 'success'
      else
        status = 'failure'
      end
    else
      status = 'failure'
    end
    render json: { status: status, data: @word, error: @word.errors.full_messages }
  end
  
  def delete
    @word = Word.find_by_id(params[:id]) || not_found
    glossary = Glossary.find_by_name(params[:name])
    if glossary and glossary.user_id == current_user.id and @word.glossary == glossary
      if @word.destroy
        status = 'success'
      else
        status = 'failure'
      end
    else
      status = 'failure'
    end
    render json: { status: status }
  end
  
  private
    def verify_signed_in
      redirect_to login_path unless signed_in?
    end
    
    def verify_glossary
      @glossary = Glossary.find_by_name(params[:name])
      not_found unless @glossary and @glossary.user_id == current_user.id      
    end
end
