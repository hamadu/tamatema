# encoding: utf-8

class StaticPagesController < ApplicationController
  def home
    @recent_glossaries = Glossary.where("private != '#{Glossary::PRIVATE_ONLY}'").order("updated_at DESC").limit(10)
    
    @popular_counts = Glossary.joins(:count).where("private != '#{Glossary::PRIVATE_ONLY}'").order("counts.week DESC").limit(10)
  end

  def help
    redirect_to '/g/help'
  end

  def about
  end
end
