class User < ActiveRecord::Base
  has_secure_password
  has_many :orders

  has_many :user_stores
  has_many :stores, through: :user_stores

  has_many :user_roles
  has_many :roles, through: :user_roles

  validates :username, presence: true,
                       uniqueness: true

  def registered_user?
    roles.exists?(name: "registered_user")
  end

  def store_admin?
    roles.exists?(name: "store_admin")
  end
end
