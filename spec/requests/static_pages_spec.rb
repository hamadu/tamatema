# encoding: utf-8

require 'spec_helper'

describe "StaticPages" do
  describe "GET /" do
    it "should have service title" do
      visit root_path
      page.should have_content('用語集メーカー');
    end
    
    it "should have the right title" do
      visit root_path
      page.should have_selector('title', :text => full_title(''))
    end
  end
  
  describe "GET /help" do
    it "should have the right title" do
      visit help_path
      page.should have_selector('title', :text => full_title('ヘルプ'))
    end
  end

  describe "GET /login" do
    it "should have the right title" do
      visit login_path
      page.should have_selector('title', :text => full_title('ログイン'))
    end
  end
end
