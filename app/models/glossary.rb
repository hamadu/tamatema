class Glossary < ActiveRecord::Base
  attr_accessible :description, :name, :title
  
  belongs_to :user
  has_many :words

  VALID_NAME_REGEX = /\A[a-z\-~_]+\z/i
  validates :name, presence: true, length: { maximum: 32 }, 
    format: { with: VALID_NAME_REGEX }, uniqueness: true
  validates :title, presence: true, length: { maximum: 128 }
  validates :description, length: { maximum: 1024 }
  validates :user_id, presence: true
end
