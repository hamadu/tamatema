# encoding: utf-8

require 'spec_helper'

describe "Authentication" do
  subject { page }
  describe "GET /login" do
    before { visit login_path }
    
    it { should have_selector('h1', text: 'ログイン') }
    it { should have_selector('title', text: 'ログイン') }
  end
  
  describe "POST /login" do
    before { visit login_path }
    describe "insufficient information" do
      before { click_button "ログイン" }
      
      it { should have_selector('title', text: 'ログイン') }
      it { should have_selector('div.alert.alert-error', text: 'メールアドレスまたはパスワードが違います。') }
    end
    
    describe "valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email", with:user.email
        fill_in "Password", with:user.password
        click_button "ログイン"
      end
      
      it { should have_selector('title', text: user.name) }
    end
  end
end
