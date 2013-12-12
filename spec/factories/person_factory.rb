FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "email#{n}@test.com"
    end
    password "password"
    username "test"
    admin false
    approved true
  end
end