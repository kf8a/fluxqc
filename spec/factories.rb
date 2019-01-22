FactoryBot.define do
  factory :measurement do
    excluded  { false }
  end
  factory :flux do
  end
  factory :compound do
    name { 'co2' }
    ymax  { 5000 }
  end
  factory :incubation do
  end
  factory :lid do
  end
  factory :run do
  end
  factory :user do
    email     { 'bob@test.com' }
    password  { '123testing' }
  end
  factory :standard_curve do
  end
end
