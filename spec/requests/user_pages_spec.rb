# encoding: utf-8

require 'spec_helper'

describe "UserPages" do
  subject { page }
  
  describe "GET /register" do
    before { visit register_path }
    it { should have_selector('h1', text:'ユーザ登録') }
    it { should have_selector('title', text:full_title('ユーザ登録')) }
  end
end
