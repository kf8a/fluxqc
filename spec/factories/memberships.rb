# Read about factories at http://github.com/thoughtbot/factory_bot

FactoryBot.define do
  factory :membership do
    group_id 1
    user_id 1
    name "MyString"
  end
end
