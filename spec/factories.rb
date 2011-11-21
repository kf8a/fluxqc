FactoryGirl.define do
  factory :measurement do
    excluded  false
  end
  factory :flux do
  end
  factory :compound do
    name 'co2'
  end
  factory :incubation do
  end
  factory :lid do
    headspace 1
  end
  factory :run do
  end
  factory :user do
    email     'bob@test.com'
    password  'testing'
  end
end
