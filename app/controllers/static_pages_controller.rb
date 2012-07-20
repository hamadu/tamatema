# encoding: utf-8

class StaticPagesController < ApplicationController
  def home
    @glossaries = Glossary.order("updated_at DESC").limit(10)
  end

  def help
  end

  def about
  end
end
