# encoding: utf-8

class StaticPagesController < ApplicationController
  def home
    @recent_glossaries = Glossary.order("updated_at DESC").limit(10)
    
    @popular_counts = Glossary.joins(:count).order("counts.week DESC").limit(10)

    
    # Glossary.order("count.week DESC").limit(10)
  end

  def help
  end

  def about
  end
end
