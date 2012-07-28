class Glossary < ActiveRecord::Base
  PRIVATE_ONLY = "O"
  PRIVATE_SELF = "S"
  PRIVATE_USER = "U"
  PRIVATE_PUBLIC = "P"
  
  attr_accessible :description, :name, :title, :private
  
  belongs_to :user
  has_many :words, :dependent => :destroy
  has_one :count, :dependent => :destroy

  VALID_NAME_REGEX = /\A[a-z\-~_]+\z/i
  validates :name, presence: true, length: { maximum: 32 }, 
    format: { with: VALID_NAME_REGEX }, uniqueness: true
  validates :title, presence: true, length: { maximum: 128 }
  validates :description, length: { maximum: 1024 }
  validates :user_id, presence: true
  validates :private, presence: true, :format => { :with => /\A[OSUP]\z/ }

  def can_see(user)
    return true if (user == self.user && self.private == Glossary::PRIVATE_ONLY)
    return false if (self.private == Glossary::PRIVATE_ONLY)
    return true
  end
  
  def can_edit(user)
    return false if user == nil
    (user == self.user || self.private == Glossary::PRIVATE_USER)
  end
  
  def week_count
    create_count_ifnil
    self.count.week
  end
  
  def total_count
    create_count_ifnil
    self.count.total
  end
  
  def countup
    create_count_ifnil
    self.count.up
  end
  
  def stars
    WordStar.joins(:word).where("words.glossary_id = '#{self.id}'")
  end
  
  
  def create_count_ifnil
    if self.count == nil then
      self.count = Count.new(week: 0, total: 0, glossary_id: self.id)
      self.count.save
    end    
  end
end
