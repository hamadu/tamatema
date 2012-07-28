require 'spec_helper'

describe WordStar do
  let(:word) { FactoryGirl.create(:word) }
  let(:glossary) { word.glossary }
  let(:user) { glossary.user }
  let(:ya_user) { FactoryGirl.create(:user, name: "ya_user") }
  let(:word_star) { user.word_stars.build(word_id: word.id) }
  let(:word_star_ya) { word.word_stars.build(user_id: ya_user) }
  
  subject { word_star }
  
  it { should be_valid }
  it { word_star_ya.should be_valid }
  
  describe "when user_id is not present" do
    before { word_star.user_id = nil }
    it { should_not be_valid }
  end
  describe "when word_id is not present" do
    before { word_star.word_id = nil }
    it { should_not be_valid }
  end
end
