# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :review do
    body 'This book is good.'
    book
    user
  end
end
