class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation, :temporary_key
  has_secure_password
  
  has_many :glossaries  
  
  validates :name, presence: true, length:{ maximum: 32 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format:{ with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  
  before_save :create_remember_token
  
  private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
