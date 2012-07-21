class Glossary < ActiveRecord::Base
  PRIVATE_ONLY = "O"
  PRIVATE_SELF = "S"
  PRIVATE_USER = "U"
  PRIVATE_PUBLIC = "P"
  
  attr_accessible :description, :name, :title, :private
  
  belongs_to :user
  has_many :words

  VALID_NAME_REGEX = /\A[a-z\-~_]+\z/i
  validates :name, presence: true, length: { maximum: 32 }, 
    format: { with: VALID_NAME_REGEX }, uniqueness: true
  validates :title, presence: true, length: { maximum: 128 }
  validates :description, length: { maximum: 1024 }
  validates :user_id, presence: true
  validates :private, presence: true, :format => { :with => /\A[OSUP]\z/ }
  
  def can_edit(user)
    return false if user == nil
    (user == self.user || self.private == Glossary::PRIVATE_USER)
  end
end
