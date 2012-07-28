# encoding: utf-8

require 'spec_helper'

describe "StaticPages" do
  subject { page }
  service_title = "たまてま"
  
  describe "GET /" do
    before { visit root_path }
    it { should have_content(service_title) }
    it { should have_selector('title', text: full_title('')) }
    it { should have_link('Twitterでログイン', href: '/auth/twitter') }
  end

  describe "GET /about" do
    before { visit about_path }
    it { should have_link(service_title, href:root_path) }

    it { should have_selector('h1', text:'About') }        
    it { should have_selector('title', text:full_title('About')) }
  end
end
