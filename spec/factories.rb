# encoding: utf-8

FactoryGirl.define do
  factory :user do
    name "山田太郎"
    email "yamada@example.com"
    password "aaaaaa"
    password_confirmation "aaaaaa"
  end
  
  factory :glossary do
    name "glsry"
    title "My Glossary"
    description "descr"
    user
  end
  
  factory :word do
    name "sample word"
    description "word description in detail"
    glossary
  end
end