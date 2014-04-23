# A user that can log into the system
# Users are created from the console as there are only a few
# and users should not be able to sign up
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable,
  # :timeoutable, :registerable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :company
  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  persistence_token      :string(255)
#  password_salt          :string(255)
#  last_request_at        :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  name                   :string(255)
#  email                  :string(255)
#  encrypted_password     :string(255)
#  reset_password_token   :string(255)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  remember_created_at    :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  sign_in_count          :integer
#  reset_password_sent_at :datetime
#  company_id             :integer
#
