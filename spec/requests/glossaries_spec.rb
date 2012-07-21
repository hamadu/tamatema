# encoding: utf-8

require 'spec_helper'

describe "Glossary" do
  subject { page }
  let(:glossary) { FactoryGirl.create(:glossary) }
  let(:user) { glossary.user }
  describe "without login" do
    describe "GET /g/(name)" do
      before { visit glossary_path(glossary.name) }
      it { should have_selector('h1', text: glossary.title) }
      it { should have_selector('title', text: glossary.title) }
    end
    
    describe "GET /g/new" do
      before { visit new_glossary_path }
      it { should have_selector('h1', text: "ログイン") }
    end
    
    describe "POST /g" do
      before { post glossary_path }
      specify { response.should redirect_to(login_path) }
    end
  end

  describe "after login" do
    before { sign_in user }
    describe "GET /g/(name) with login" do
      before { visit glossary_path(glossary.name) }
      it { should have_selector('h1', text: glossary.title) }
      it { should have_selector('title', text: glossary.title) }
    end
    
    describe "GET /g/(notfound)" do
      it "should not found" do
        expect { visit glossary_path("not-exist") }.to raise_error(ActionController::RoutingError)
      end
    end

    describe "GET /g/new" do
      let(:new_page_title) { "新しい用語集を作る" }
      before { visit new_glossary_path }
      it { should have_selector('h1', text: new_page_title) }
      it { should have_selector('title', text: new_page_title) }
      
      let(:submit) { "作成する" }
      describe "insufficient information" do
        it "should not create new glossary" do
          expect { click_button submit }.not_to change(Glossary, :count)
        end
        describe "after submission" do
          before { click_button submit }
          it { should have_selector('title', text: new_page_title) }
          it { should have_content('登録エラー') }
        end      
      end
      
      describe "sufficient information" do
        before do 
          fill_in "ID", with:"exampl"
          fill_in "用語集名", with:"Example GLSL"
          choose "glossary_private_s"
        end
        it "should create new glossary" do
          expect { click_button submit }.to change(Glossary, :count).by(1)
        end
        describe "after submission" do
          before { click_button submit }
          it { should have_selector('title', text: "Example GLSL") }
          it { should have_content('登録完了！') }
        end
      end
    end
    
    describe "GET /g/(:name)/edit" do
      let(:update_page_title) { "用語集「#{glossary.title}」を編集する" }
      before { visit edit_glossary_path(glossary.name) }
      it { should have_selector('h1', text: update_page_title) }
      it { should have_selector('title', text: update_page_title) }      
      
      let(:submit) { "更新する" }
      describe "insufficient information" do
        before do
          fill_in "ID", with: ""
          fill_in "用語集名", with: ""
        end
        describe "after submission" do
          before { click_button submit }
          it { should have_selector('h1', text: update_page_title) }
          it { should have_content("登録エラー") }
        end    
      end
      
      describe "invalid information" do
        before do
          find(:xpath, "//input[@id='glossary_id']").set "999"
        end
        it "should route not found" do
          expect { click_button submit }.to raise_error(ActionController::RoutingError)
        end    
      end
      
      describe "sufficient information" do
        before do
          fill_in "ID", with: "newname"
          fill_in "用語集名", with: "New Name"
        end        
        describe "after submission" do
          it "should update new glossary" do
            expect { click_button submit }.to change(Glossary, :count).by(0)
          end
          describe "after submission" do
            before { click_button submit }
            it { should have_selector("title", text: "New Name") }
            it { should have_content("更新完了！") }
          end
        end        
      end
    end
  end
end
