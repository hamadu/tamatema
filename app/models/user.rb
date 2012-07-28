class User < ActiveRecord::Base
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["nickname"]
    end
    User.find_by_provider_and_uid(auth["provider"], auth["uid"])
  end
  
  attr_accessible :name, :uid, :provider, :temporary_key
  
  has_many :glossaries
  has_many :word_stars
  
  validates :name, presence: true, length:{ maximum: 32 }

  before_save :create_remember_token
  
  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
