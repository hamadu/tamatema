# encoding: utf-8

require 'spec_helper'

describe "Users" do
  subject { page }
  
  describe "GET /register" do
    before { visit register_path }
    it { should have_selector('h1', text:'ユーザ登録') }
    it { should have_selector('title', text:full_title('ユーザ登録')) }
    
    let(:submit) { "ユーザ登録" }
    describe "insufficient information" do
      it "should not create user" do
        expect { click_button submit }.not_to change(User, :count)
      end
      describe "after submission" do
        before { click_button submit }
        it { should have_selector('title', text:'ユーザ登録') }
        it { should have_content('登録エラー') }
      end
    end
    
    
    describe "valid information" do
      before do
        fill_in "Name", with:"Example User"
        fill_in "Email", with:"user@example.com"
        fill_in "Password", with:"aaaaaa"
        fill_in "Confirmation", with:"aaaaaa"
      end
      it "should create user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      describe "after submission" do
        before { click_button submit }
        it { should have_selector('title', text:"Example User") }
        it { should have_content('登録完了！') }
        it { should have_link('ログアウト', href: logout_path) }
      end
    end

  end
  
  describe "GET /users/show/id" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }
    
    it { should have_selector('h1', text:user.name) }
    it { should have_selector('title', text:user.name)}
  end
end
