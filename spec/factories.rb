# encoding: utf-8

FactoryGirl.define do
  factory :user do
    name "山田太郎"
    uid "aaaaaaaaaaaaaaaaaaaa"
    provider "twitter"
  end
  
  factory :glossary do
    name "glsry"
    title "My Glossary"
    private Glossary::PRIVATE_SELF
    description "descr"
    user
  end
  
  factory :word do
    name "sample word"
    description "word description in detail"
    glossary
  end
end