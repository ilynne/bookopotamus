# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :book do
    title     'Book Title from Factory'
    isbn      '1234567890'
  end
end
