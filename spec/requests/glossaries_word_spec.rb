# encoding: utf-8

require 'spec_helper'

describe "Word" do
  subject { page }
  let(:word) { FactoryGirl.create(:word) }
  let(:glossary) { word.glossary }
  let(:user) { glossary.user }

  
  let(:ya_user) { FactoryGirl.create(:user, name: "ya_user", uid: "ya_uid") }
  let(:ya_glossary) { FactoryGirl.create(:glossary, name: "ya_glossary", user: ya_user) }
  let(:ya_word) { FactoryGirl.create(:word, name: "ya_word", glossary: ya_glossary) }

  let(:create_post_params) do
    {
      "glossary_id" => glossary.id,
      "word[name]" => "newword",
      "word[description]" => "newword description",          
    }
  end

  let(:create_post_params_with_read) do
    {
      "glossary_id" => glossary.id,
      "word[name]" => "newword",
      "word[read]" => "readread",
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
  
  describe "without login" do
    describe "GET /g/(name)/new" do
      before { get new_word_path(glossary.name) }
      specify { response.should redirect_to(login_path) }
    end
    
    describe "POST /g/(name)/new" do
      before { post create_word_path(glossary.name), create_post_params }
      specify { response.should redirect_to(login_path) }
    end
    
    describe "GET /g/(name)/(id)" do
      before { get edit_word_path(glossary.name, word.id) }
      specify { response.should redirect_to(login_path) }
    end
    
    describe "POST /g/(name)/(id)" do
      before { post update_word_path(glossary.name, word.id), update_post_params }
      specify { response.should redirect_to(login_path) }      
    end
    
    describe "POST /g/(name)/(id)/delete" do
      before { post delete_word_path(glossary.name, word.id) }
      specify { response.should redirect_to(login_path) }
    end
  end
  
  
  describe "with login" do
    before { sign_in user }
    describe "GET /g/(name)/new" do
      let(:new_page_title) { "言葉を追加する" }
      describe "ok" do
        before { visit new_word_path(glossary.name) }
        it { should have_selector('h3', text: new_page_title) }
      end
      
      describe "glossary which is not exist" do
        it "should cause RouteError" do
          expect { visit new_word_path("dont_exist") }.to raise_error(ActionController::RoutingError)
        end
      end

      describe "another user's glossary" do
        it "should cause RouteError" do
          expect { visit new_word_path(ya_glossary.name) }.to raise_error(ActionController::RoutingError)
        end
      end
    end
    
    describe "POST /g/(name)/new" do
      describe "ok" do
        describe "response should success" do
          before { post create_word_path(glossary.name), create_post_params }
          it { response.body.should have_content('success') }
        end
        it "should change word count" do
          expect { post create_word_path(glossary.name), create_post_params }.to change(Word, :count).by(1)
        end
      end
      
      describe "ok with read" do
        describe "response should success" do
          before { post create_word_path(glossary.name), create_post_params_with_read }
          it { response.body.should have_content('success') }
          it { response.body.should have_content("\"name\":\"#{create_post_params_with_read["word[name]"]}\"") }
          it { response.body.should have_content("\"read\":\"#{create_post_params_with_read["word[read]"]}\"") }
        end
        it "should change word count" do
          expect { post create_word_path(glossary.name), create_post_params_with_read }.to change(Word, :count).by(1)
        end
      end

      
      describe "different glossary" do
        describe "response should failure" do
          before { post create_word_path(ya_glossary.name), create_post_params }
          it { response.body.should have_content('failure') }
        end
        it "should not change word count" do
          expect { post create_word_path(ya_glossary.name), create_post_params }.to change(Word, :count).by(0)
        end
      end
    end
    
    
    describe "GET /g/(name)/(id)" do
      let(:edit_page_title) { "言葉を編集する" }
      
      describe "my word" do
        before { visit edit_word_path(glossary.name, word.id) }
        describe "should have content" do
          it { should have_selector('h3', text: edit_page_title) }
          it { should have_selector("input[id='word_id'][value='#{word.id}']") }
          it { should have_selector("input[id='word_name'][value='#{word.name}']") }
          it { should have_selector("textarea[id='word_description']", text: word.description) }
        end
      end
      
      describe "unknown word" do
        it "unkown word" do
          expect { get edit_word_path(glossary.name, "3") }.to raise_error(ActionController::RoutingError)
        end
        it "other word" do
          expect { get edit_word_path(ya_glossary.name, ya_word.id) }.to raise_error(ActionController::RoutingError)
        end
        it "unkown glossary" do
          expect { get edit_word_path("unkown_glossary", ya_word.id) }.to raise_error(ActionController::RoutingError)
        end
      end
      
    end
    
    describe "POST /g/(name)/(id)/delete" do
      describe "OK" do
        describe "response should success" do
          before { post delete_word_path(glossary.name, word.id) }
          it { response.body.should have_content('success') }
        end
        it "should decrease word count" do
          expect {
            post delete_word_path(glossary.name, word.id)
          }.to change(Word, :count).by(-1)
        end        
      end
      
      describe "NG" do
        describe "non-existing word" do
          it "should raise route error" do
            expect {
              post delete_word_path(glossary.name, "999")
            }.to raise_error(ActionController::RoutingError)
          end          
        end
        
        describe "mismatching glossary-word map" do
          before { post delete_word_path(glossary.name, ya_word.id) }
          it { response.body.should have_content('failure') }
        end
        
        describe "other's word" do
          before { post delete_word_path(ya_glossary.name, ya_word.id) }
          it { response.body.should have_content('failure') }
        end
      end
    end
    
    describe "POST /g/(name)/(id)" do
      describe "OK" do
        describe "response should success" do
          before { post update_word_path(glossary.name, word.id), update_post_params }
          it { response.body.should have_content('success') }
          it { response.body.should have_content("\"name\":\"#{update_post_params["word[name]"]}\"") }
          it { response.body.should have_content("\"read\":\"#{update_post_params["word[name]"]}\"") }
        end
        it "should not change word count" do
          expect {
            post update_word_path(glossary.name, word.id), update_post_params
          }.to change(Word, :count).by(0)
        end
      end
      
      describe "NG" do
        describe "non-existing word" do
          it "should raise route error" do
            expect {
              post update_word_path(glossary.name, "999"), update_post_params
            }.to raise_error(ActionController::RoutingError)
          end
        end

        describe "mismatching glossary-word map" do
          before { post update_word_path(glossary.name, ya_word.id), update_post_params }
          it { response.body.should have_content('failure') }
        end
        
        describe "other's word" do
          before { post update_word_path(ya_glossary.name, ya_word.id), update_post_params }
          it { response.body.should have_content('failure') }
        end
      end
    end
  end
end
