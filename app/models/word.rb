class Word < ActiveRecord::Base
  attr_accessible :description, :name
  
  belongs_to :glossary
  validates :name, presence: true, length: { maximum: 128 }
  validates :description, length: { maximum: 1023 }
  validates :glossary_id, presence: true
end
