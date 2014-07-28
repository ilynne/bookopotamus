# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "arthur_dent#{n}@example.org"  } 
    password 'DentArthurDent'
    password_confirmation 'DentArthurDent'
  end
end
