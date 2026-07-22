class User < ApplicationRecord

  attr_accessor :remember_token
  # before_save() {code block to execute when before_save() hook triggered}
  # or it is the same as
  # before_save do
  #   some codes here
  # end
  before_save { self.email = email.downcase }
  # validates(attribute_to_be_validate, {validation options})
  validates(
    :name,
    {
      presence: true,
      length: { maximum: 50 }
    }
  )

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i
  validates(
    :email,
    {
      presence: true,
      length: { maximum: 255 },
      format: { with: VALID_EMAIL_REGEX },
      uniqueness: { case_sensitive: false }
    }
  )

  # has_secure_password can
  # 1. Store hashed pswd into password_digest attribute
  # 2. Access 2 virtual attributes password & password_confirmation;
  #    presence and matching validations are auto added.
  # 3. authenticate() method. Returns the user object if pswd is correct, false otherwise
  has_secure_password
  validates(
    :password,
    {
      presence: true,
      length: { minimum: 8 }
    }
  )

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember 
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    self.remember_digest
  end

  def session_token
    self.remember_digest || self.remember()
  end

  def forget 
    update_attribute(:remember_digest, nil)
  end

  def authenticated?(remember_token)
    return false if self.remember_digest.nil?
    BCrypt::Password.new(self.remember_digest).is_password?(remember_token)
  end

end
