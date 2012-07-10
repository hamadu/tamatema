# encoding: utf-8

require 'spec_helper'

describe User do
  before {
    @user = User.new(
      name: "Example User",
      email: "user@example.com",
      password: "a" * 6,
      password_confirmation: "a" * 6
    )
  }
  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:temporary_key) }
  it { should respond_to(:remember_token) }

  it { should respond_to(:authenticate) }
  
  

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
    describe "duplicate email" do
      before {
        @user2 = @user.dup
        @user2.save
      }
      it { should_not be_valid }
    end
  end
  
  describe "password" do
    describe "password is not present" do
      before { @user.password = @user.password_confirmation = "" }
      it { should_not be_valid }
    end
    describe "password is too short" do
      before { @user.password = @user.password_confirmation = "a" * 5 }
      it { should_not be_valid }
    end
    describe "password don't match confirmation" do
      before {
        @user.password = "a" * 6
        @user.password_confirmation = "b" * 6
      }
      it { should_not be_valid }
    end
  end
  
  describe "authentication" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "valid" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "invalid" do
      let(:user_with_invalid_password) { found_user.authenticate("different_password") }
      it { should_not == user_with_invalid_password }
      specify { user_with_invalid_password.should be_false }
    end
  end
  
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
end
