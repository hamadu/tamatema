require 'spec_helper'

describe Word do
  let(:glossary) { FactoryGirl.create(:glossary) }
  before do
    @word = glossary.words.build(
      name: "wd1",
      description: "desc desc desc"
    )
  end
  
  subject { @word }
  
  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:glossary_id) }
  it { should respond_to(:glossary) }
  
  it { should be_valid }
  
  
  describe "name" do
    describe "name is not present" do
      before { @word.name = '' }
      it { should_not be_valid }      
    end
    describe "name is too long" do
      before { @word.name = 'a' * 129 }
      it { should_not be_valid }
    end
    describe "when email address is already taken" do
      before do
        duplicate_word = @word.dup
        duplicate_word.save
      end
      it { should_not be_valid }
    end    
  end
  
  describe "description" do
    describe "empty description is ok" do
      before { @word.description = "" }
      it { should be_valid }
    end
    describe "too long description" do
      before { @word.description = "a" * 1025 }
      it { should_not be_valid }
    end
  end
  
  describe "glossary_id" do
    describe "glossary_id is not present" do
      before { @word.glossary_id = nil }
      it { should_not be_valid }
    end
    it "should not access to glossary_id" do
      expect do
        Word.new(glossary_id: glossary.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
end
