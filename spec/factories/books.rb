# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :book do
    sequence(:title) { |n| "Book Title #{n} from Factory" }
    sequence(:isbn_10) { |n| n + 1_234_657_890 }
    sequence(:isbn_13) { |n| "123-#{n + 1_234_657_890}" }
    sequence(:author_last) { |n| "Last #{n}" }
    sequence(:author_first) { |n| "First #{n}" }
    user
  end
end
