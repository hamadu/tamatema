# encoding: utf-8

require 'spec_helper'

describe Glossary do
  let(:user) { FactoryGirl.create(:user) }
  before {
    @glossary = user.glossaries.build(
      name: "glsr",
      title: "My Glossary",
      description: "Descri!"
    )
  }
  subject { @glossary }
  
  it { should respond_to(:name) }
  it { should respond_to(:title) }
  it { should respond_to(:description) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }
    
  it { should be_valid }
  
  describe "name" do
    describe "name is not present" do
      before { @glossary.name = '' }
      it { should_not be_valid }
    end
    
    describe "name is too long" do
      before { @glossary.name = 'a' * 33 }
      it { should_not be_valid }
    end

    describe "name with invalid format" do
      names = ["test test", "あいうえお", "gob@s", "tndl+tnd+l", "ufx_f_=f_f_f", "uh%oh"]
      names.each do |n|
        before { @glossary.name = n }
        it { should_not be_valid }
      end
    end

    describe "name with valid format" do
      names = ["test", "_____", "aaaaaaaaaa-aaaaaaaaaa-aaaaaaaaaa", "~whoawhoa", "~-~-~-~-~-"]
      names.each do |n|
        before { @glossary.name = n }
        it { should be_valid }
      end
    end    
  end

  describe "title" do
    describe "title is not present" do
      before { @glossary.title = '' }
      it { should_not be_valid }      
    end
    describe "title is too long" do
      before { @glossary.title = 'a' * 129 }
      it { should_not be_valid }
    end
  end
  
  describe "description" do
    describe "empty description is ok" do
      before { @glossary.description = "" }
      it { should be_valid }
    end
    describe "too long description" do
      before { @glossary.description = "a" * 1025 }
      it { should_not be_valid }
    end
  end
  
  describe "user_id" do
    describe "user_id is not present" do
      before { @glossary.user_id = nil }
      it { should_not be_valid }
    end
    it "should not access to user_id" do
      expect do
        Glossary.new(user_id: user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
end
