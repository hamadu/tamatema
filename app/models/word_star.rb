class WordStar < ActiveRecord::Base
  attr_accessible :user_id, :word_id
  belongs_to :word
  belongs_to :user
  
  validates :user_id, presence: true
  validates :word_id, presence: true
end
