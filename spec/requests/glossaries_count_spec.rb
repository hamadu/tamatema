# encoding: utf-8

require 'spec_helper'

describe "Glossary" do
  subject { page }
  let(:glossary) { FactoryGirl.create(:glossary) }
  let(:user) { glossary.user }
  let(:counter) {
    glossary.create_count_ifnil
    glossary.count
  }
  let(:ya_user) { FactoryGirl.create(:user, name: "ya_name", uid: "ya_uid") }
  
  describe "GET /g/(name)" do
    describe "without login" do
      describe "single visit" do
        before { visit glossary_path(glossary.name) }
        it { counter.total.should == 0 }
      end
    end

    describe "with login" do
      before { sign_in user }
      describe "single visit" do
        before { visit glossary_path(glossary.name) }
        it { counter.total.should == 0 }
      end
    end
    
    describe "with login" do
      before { sign_in ya_user }
      describe "single visit" do
        before { visit glossary_path(glossary.name) }
        it { glossary.count.total.should == 1 }
      end
    end    
  end
end
