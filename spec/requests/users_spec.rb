# encoding: utf-8

require 'spec_helper'

describe "Users" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:ya_user) { FactoryGirl.create(:user, name: "another user", email: "another@example.com") }
  
  let(:glossary_1) { FactoryGirl.create(:glossary, name: "glossary_one", title: "glsry one", user: user) }
  let(:g1_words) {
    for i in 1..100
      FactoryGirl.create(:word, name: "word#{i}", description: "desc", glossary: glossary_1)
    end
  }
  let(:glossary_2) { FactoryGirl.create(:glossary, name: "glossary_two", title: "glsry two", user: user) }
  

  describe "before login" do
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
      before { visit user_path(user) }
      it { should have_selector('h1', text:user.name) }
      it { should have_selector('title', text:user.name)}
    end
    
    describe "GET /users/edit" do
      before { get edit_user_path }
      specify { response.should redirect_to(login_path) }
    end

    describe "POST /users/edit" do
      before { post update_user_path }
      specify { response.should redirect_to(login_path) }
    end
    
    describe "GET /users/delete_confirm" do
      before { get delete_confirm_user_path }
      specify { response.should redirect_to(login_path) }
    end
    
    describe "POST /users/delete" do
      before { post delete_user_path }
      specify { response.should redirect_to(login_path) }
    end
  end
  
  
  describe "after login" do
    before { sign_in user }
    describe "GET /users/show/id" do
      before { 
        g1_words
        visit user_path(user)
      }
      it { should have_selector('h2', text: 'ユーザ情報を編集する') }
      it { should have_link("プロフィールを編集する", href: edit_user_path) }
      it { should have_selector('h2', text: 'あなたの用語集') }
      it { should have_link("#{glossary_1.title}[#{glossary_1.words.size}]", href: glossary_path(glossary_1.name)) }
      it { should have_selector('h3 a', text: "#{glossary_1.title}[#{glossary_1.words.size}]") }
      it { should have_link("編集する", href: edit_glossary_path(glossary_1.name)) }
      it { should have_link("削除する", href: delete_glossary_path(glossary_1.name)) }
    end
    
    describe "GET /" do
      before { visit root_path }
      it { should have_selector('h1', text: user.name) }
      it { should have_selector('title', text: user.name)}      
    end
    
    describe "GET /users/edit" do
      before { visit edit_user_path }
      it { should have_selector("input[id='user_name'][value='#{user.name}']") }
      it { should have_selector("input[id='user_email'][value='#{user.email}']") }
    end    
    
    describe "POST /users/edit" do
      let(:submit) { "情報を更新する" }
      describe "valid information" do
        before do
          visit edit_user_path
          fill_in "Name", with: "nantara"
          fill_in "Email", with: "different@example.com"
          fill_in "Password", with: "bbbbbb"
          fill_in "Confirmation", with: "bbbbbb"
        end
        it "should not change user number" do
          expect { click_button submit }.not_to change(User, :count)
        end
        describe "should change user info" do
          before { click_button submit }
          it { User.find_by_name("nantara").should_not be_nil }
          it { User.find_by_name("山田太郎").should be_nil }
          it { User.find_by_email("different@example.com").should_not be_nil }
          it { User.find_by_email("yamada@example.com").should be_nil }
        end
      end
      
      describe "valid information (without password)" do
        before do
          visit edit_user_path
          fill_in "Name", with: "nantara"
          fill_in "Email", with: "different@example.com"
        end
        it "should not change user number" do
          expect { click_button submit }.not_to change(User, :count)
        end
        describe "should change user info" do
          before { click_button submit }
          it { User.find_by_name("nantara").should_not be_nil }
          it { User.find_by_name("山田太郎").should be_nil }
          it { User.find_by_email("different@example.com").should_not be_nil }
          it { User.find_by_email("yamada@example.com").should be_nil }
        end
      end
    end
  end
  
  describe "after login with another user" do
    before { sign_in ya_user }
    describe "look my page" do
      before { visit root_path }
    end
    describe "look other user's page" do
      before { 
        g1_words
        visit user_path(user)
      }
      it { should_not have_selector('h2', text: 'ユーザ情報を編集する') }
      it { should have_selector('h2', text: "#{user.name}の用語集") }
      it { should have_link("#{glossary_1.title}[#{glossary_1.words.size}]", href: glossary_path(glossary_1.name)) }
      it { should have_selector('h3 a', text: "#{glossary_1.title}[#{glossary_1.words.size}]") }
      it { should_not have_link("編集する", href: edit_glossary_path(glossary_1.name))}
      it { should_not have_link("削除する", href: delete_glossary_path(glossary_1.name))}
    end
  end
end
