# encoding: utf-8

require 'spec_helper'

describe "Word" do
  subject { page }
  let(:word) { FactoryGirl.create(:word) }
  let(:glossary) { word.glossary }
  let(:user) { glossary.user }

  let(:ya_user) { FactoryGirl.create(:user, name: "ya_user", uid: "ya_uid") }
  let(:ya_glossary_self) { FactoryGirl.create(:glossary, name: "ya_glossary_self", user: ya_user, private: Glossary::PRIVATE_SELF) }
  let(:ya_word_self) { FactoryGirl.create(:word, name: "ya_word", glossary: ya_glossary_self) }
  let(:ya_glossary_user) { FactoryGirl.create(:glossary, name: "ya_glossary_user", user: ya_user, private: Glossary::PRIVATE_USER) }
  let(:ya_word_user) { FactoryGirl.create(:word, name: "ya_word", glossary: ya_glossary_user) }

  let(:create_post_params) do
    {
      "glossary_id" => glossary.id,
      "word[name]" => "newword",
      "word[description]" => "newword description",          
    }
  end

  let(:update_post_params) do
    {
      "glossary_id" => glossary.id,
      "word[id]" => word.id,
      "word[name]" => "newword",
      "word[description]" => "newword description",          
    }
  end

  after(:all)  { User.delete_all }
  
  describe "with login" do
    before { sign_in user }
    describe "GET /g/(name)/new" do
      let(:new_page_title) { "言葉を追加する" }
      describe "ng with self glossary" do
        it "should raise error" do
          expect { visit new_word_path(ya_glossary_self.name) }.to raise_error(ActionController::RoutingError)
        end
      end
      describe "ok with user glossary" do
        before { visit new_word_path(ya_glossary_user.name) }
        it { should have_selector('h3', text: new_page_title) }
      end
    end
    
    describe "POST /g/(name)/new" do
      describe "ng with self glossary" do
        before { post create_word_path(ya_glossary_self.name), create_post_params }
        it { response.body.should have_content('failure') }
      end
      describe "ok with user glossary" do
        before { post create_word_path(ya_glossary_user.name), create_post_params }
        it { response.body.should have_content('success') }
      end
    end
    
    
    describe "GET /g/(name)/(id)" do
      let(:edit_page_title) { "言葉を編集する" }
      describe "ng with self glossary" do
        it "should rase error" do
          expect { get edit_word_path(ya_glossary_self.name, ya_word_self.id) }.to raise_error(ActionController::RoutingError)
        end
      end
      describe "ok with user glossary" do
        before { visit edit_word_path(ya_glossary_user.name, ya_word_user.id) }
        describe "should have content" do
          it { should have_selector('h3', text: edit_page_title) }
          it { should have_selector("input[id='word_id'][value='#{ya_word_user.id}']") }
          it { should have_selector("input[id='word_name'][value='#{ya_word_user.name}']") }
          it { should have_selector("textarea[id='word_description']", text: ya_word_user.description) }
        end
      end
    end
    
    describe "POST /g/(name)/(id)/delete" do
      describe "ng with self glossary" do
        before { post delete_word_path(ya_glossary_self.name, ya_word_self.id) }
        it { response.body.should have_content('failure') }
      end
      describe "ok with user glossary" do
        before { post delete_word_path(ya_glossary_user.name, ya_word_user.id) }
        it { response.body.should have_content('success') }
      end
    end
    
    describe "POST /g/(name)/(id)" do
      describe "ng with self glossary" do
        before { post update_word_path(ya_glossary_self.name, ya_word_self.id), update_post_params }
        it { response.body.should have_content('failure') }
      end
      describe "ok with user glossary" do
        before { post update_word_path(ya_glossary_user.name, ya_word_user.id), update_post_params }
        it { response.body.should have_content('success') }
      end
    end
  end
end
