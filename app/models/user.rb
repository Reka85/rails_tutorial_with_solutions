class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i # {1} added
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, length: {minimum: 6}, presence: true # without he could choose pw-s with 6+ whitespaces

  #returns hash digest of a string
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  #return a random token (for remember token)
  def self.new_token
    SecureRandom.urlsafe_base64
  end
  #remembers a user in teh db for use in persistent sessions
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  # retuns true if the token matches the digest
  def authenticated?(remember_token)# it is not the same as remember_token above
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
