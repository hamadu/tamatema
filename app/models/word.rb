class Word < ActiveRecord::Base
  attr_accessible :description, :glossary_id, :name
end
