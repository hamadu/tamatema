# encoding: utf-8

FactoryGirl.define do
  factory :user do
    name "山田太郎"
    email "yamada@example.com"
    password "aaaaaa"
    password_confirmation "aaaaaa"
  end
end