require 'spec_helper'

describe "StaticPages" do
  describe "GET /static_pages/home" do
    it "should have service title" do
      visit '/static_pages/home'
      page.should have_content('Glossary Maker');
    end
    
    it "should have the right title" do
      visit '/static_pages/home'
      page.should have_selector('title', :text => "Glossary Maker")
    end
  end
  
  describe "GET /static_pages/help" do
    it "should have the right title" do
      visit '/static_pages/help'
      page.should have_selector('title', :text => "Glossary Maker | Help")
    end
  end
end
