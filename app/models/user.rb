# frozen_string_literal: true

# A user that can log into the system
# Users are created from the console as there are only a few
# and users should not be able to sign up
class User < ActiveRecord::Base
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :company
  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me
end
