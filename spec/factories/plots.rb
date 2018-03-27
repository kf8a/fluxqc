# Read about factories at http://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :plot do
    name "MyString"
  end
end

# == Schema Information
#
# Table name: plots
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#
