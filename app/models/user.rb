class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name,  presence: true, length: {maximum: Settings.user.validates_name}
  validates :email, presence: true, length: {maximum: Settings.user.validates_email},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {minimum: Settings.user.validates_password}

  before_save :email_downcase

  has_secure_password

  private

  def email_downcase
    self.email = email.downcase
  end
end
