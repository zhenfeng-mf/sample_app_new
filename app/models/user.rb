class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  attr_accessor :remember_token, :activation_token, :reset_token

  # before_save() {code block to execute when before_save() hook triggered}
  # or it is the same as
  # before_save do
  #   some codes here
  # end
  before_save :downcase_email
  before_create :create_activation_digest


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
      length: { minimum: 6 },
      allow_nil: true
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

  def authenticated?(attribute, token)
    digest = self.send("#{attribute}_digest") # digest = self.xxx_digest
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def activate
    # Access DB only one time.
    update_columns(activated: true, activated_at: Time.zone.now)
    # update_attribute(:activated,    true)
    # update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest 
    self.reset_token = User.new_token
    # update_attribute(:reset_digest, User.digest(self.reset_token))
    # update_attribute(:reset_sent_at, Time.zone.now)
    update_columns(reset_digest: User.digest(self.reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def feed 
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
             .includes(:user, image_attachment: :blob)
  end


  def follow(other_user)
    following << other_user unless self == other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  # if current user following other_user
  def following?(other_user)
    following.include?(other_user)
  end

  ###########################################   ###########################################   ########################################### 

  private

  def downcase_email
    self.email = email.downcase
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

end
