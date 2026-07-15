class User < ApplicationRecord
  # before_save() {code block to execute when before_save() hook triggered}
  # or it is the same as
  # before_save do
  #   some codes here
  # end
  before_save { self.email = email.downcase }
  # validates(attribute_to_be_validate, {validation options})
  validates(:name,
            {
              presence: true,
              length: { maximum: 50 }
            })
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i

  validates(:email,
            {
              presence: true,
              length: { maximum: 255 },
              format: { with: VALID_EMAIL_REGEX },
              uniqueness: { case_sensitive: false }
            })
end
