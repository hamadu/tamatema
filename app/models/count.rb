class Count < ActiveRecord::Base
  attr_accessible :glossary_id, :total, :week
  
  belongs_to :glossary
  validates :total, presence: true
  validates :week, presence: true
  
  def up
    self.week += 1
    self.total += 1
    self.save
  end
end
