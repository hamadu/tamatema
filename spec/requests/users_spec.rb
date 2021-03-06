# encoding: utf-8

require 'spec_helper'

describe "Users" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:ya_user) { FactoryGirl.create(:user, name: "another user", uid: "another_uid") }
  
  let(:glossary_1) { FactoryGirl.create(:glossary, name: "glossary_one", title: "glsry one", user: user) }
  let(:g1_words) {
    for i in 1..100
      FactoryGirl.create(:word, name: "word#{i}", description: "desc", glossary: glossary_1)
    end
  }
  let(:glossary_2) { FactoryGirl.create(:glossary, name: "glossary_two", title: "glsry two", user: user) }
  

  describe "before login" do
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
      it { should have_link("#{glossary_1.title}", href: glossary_path(glossary_1.name)) }
      it { should have_link("編集", href: edit_glossary_path(glossary_1.name)) }
      it { should have_link("削除") }
    end
    
    describe "GET /users/edit" do
      before { visit edit_user_path }
      it { should have_selector("input[id='user_name'][value='#{user.name}']") }
    end    
    
    describe "POST /users/edit" do
      let(:submit) { "情報を更新する" }
      describe "valid information" do
        before do
          visit edit_user_path
          fill_in "名前", with: "nantara"
        end
        it "should not change user number" do
          expect { click_button submit }.not_to change(User, :count)
        end
        describe "should change user info" do
          before { click_button submit }
          it { User.find_by_name("nantara").should_not be_nil }
          it { User.find_by_name("山田太郎").should be_nil }
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
      it { should have_link("#{glossary_1.title}", href: glossary_path(glossary_1.name)) }
      it { should_not have_link("編集", href: edit_glossary_path(glossary_1.name))}
      it { should_not have_link("削除", href: delete_glossary_path(glossary_1.name))}
    end
  end
end
