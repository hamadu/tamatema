# encoding: utf-8

require 'spec_helper'

describe "Authentication" do
  subject { page }
  let(:user) { FactoryGirl.create(:user) }  

  describe "after login" do
    describe "valid information" do
      before { sign_in user }
      it { should have_selector('title', text: user.name) }
      it { should have_link('ログアウト', href: logout_path) }
      it { should have_link("プロフィール", href: user_path(user)) }
      it { should have_link("設定") }
    end
  end
  
  describe "after logout /logout" do
    before do
      sign_in user
      visit logout_path
    end
    it { should have_selector('title', text:full_title('')) }
    it { should have_link('Twitterでログイン', href: '/auth/twitter') }
  end
end
