# encoding: utf-8

require 'spec_helper'

describe User do
  before {
    @user = User.new(
      name: "Example User"
    )
  }
  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:temporary_key) }
  it { should respond_to(:remember_token) }

  
  
  it { should be_valid }
  
  describe "name" do
    describe "name is not present" do
      before { @user.name = "" }
      it { should_not be_valid }
    end
    describe "name is too long" do
      before { @user.name = "a" * 33}
      it { should_not be_valid }
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
end
