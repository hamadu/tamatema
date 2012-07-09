# encoding: utf-8

require 'spec_helper'

describe "Users" do
  subject { page }
  
  describe "GET /register" do
    before { visit register_path }
    it { should have_selector('h1', text:'ユーザ登録') }
    it { should have_selector('title', text:full_title('ユーザ登録')) }
  end
  
  describe "GET /users/show/id" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    
    it { should have_selector('h1', text:user.name) }
    it { should have_selector('title', text:user.name)}
  end
end
