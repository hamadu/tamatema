class Glossary < ActiveRecord::Base
  attr_accessible :description, :name, :title, :user_id
end
