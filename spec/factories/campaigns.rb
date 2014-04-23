# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :campaign do
    name "MyString"
  end
end

# == Schema Information
#
# Table name: campaigns
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#
