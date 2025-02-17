class User < ApplicationRecord
  has_secure_password
  has_many :blogs, dependent: :destroy
  has_many :comments, dependent: :destroy

  # validates :name, presence: true, uniqueness: true
  # validates :email, presence: true, uniqueness: true
end
