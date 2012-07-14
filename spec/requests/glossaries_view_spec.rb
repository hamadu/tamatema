# encoding: utf-8

require 'spec_helper'

describe "Glossary" do
  subject { page }
  let(:glossary) { FactoryGirl.create(:glossary) }
  let(:user) { glossary.user }
  
  describe "GET /g/(name)" do
    describe "with no words" do
      before { visit glossary_path(glossary.name) }
      it { should have_selector('h1', text: glossary.title) }
      it { should have_selector('title', text: glossary.title) }
      it { should have_content('この用語集にはまだ単語がありません。単語を追加してみよう！') }
    end
    
    describe "with words" do
      let(:glossary_words) do
        test_glossary = FactoryGirl.create(:glossary).clone
        test_glossary.name = "test_test"
        word_key = "A"
        for _ in 1..10
          candidate_word = word_key.crypt("01")
          candidate_word.sub!(/\./, '')
          candidate_word.reverse!
          word_key.succ!
          test_glossary.words.create!(name: candidate_word, description: candidate_word * 5)
        end
        test_glossary.save
        test_glossary
      end
      before {
        visit glossary_path(glossary_words.name)
      }
      it { should_not have_content('この用語集にはまだ単語がありません。単語を追加してみよう！') }
      it "should have content" do
        for word in glossary_words.words
          index = word.name.slice(0,1)
          page.should have_selector('h2', text: index.upcase)
          page.should have_selector('h3', text: word.name)
          page.should have_selector('div.description', text: word.description)
        end
      end
      
      it "should have right index" do
        for word in glossary_words.words
          index = word.name.slice(0,1)
          page.should have_selector('div.word_index ul li', text: index.upcase)
        end
      end
    end    
  end
end
