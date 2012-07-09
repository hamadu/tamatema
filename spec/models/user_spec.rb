require 'spec_helper'

describe User do
  before {
    @user = User.new(
      name: "Example User",
      email: "user@example.com"
    )
  }
  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:temporary_key) }
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
  
  
  describe "email" do
    describe "email is not present" do
      before { @user.email = "" }
      it { should_not be_valid }
    end
    
    describe "valid email" do
      addresses = ["test@example.com", "test+TEST@example.com", "gon_gon.gon@goo.go.jp"]
      addresses.each do |address|
        before { @user.email = address }
        it { @user.should be_valid }
      end
    end
    describe "invalid email" do
      addresses = ["test_at_example.com", "test+TEST@example+z.com", "gon_gon.@goo.goo."]
      addresses.each do |address|
        before { @user.email = address }
        it { @user.should_not be_valid }
      end
    end
  end
end
