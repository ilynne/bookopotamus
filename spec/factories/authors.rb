# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :author do
    sequence(:last_name) { |n| "Prefect#{n}"  }
    sequence(:first_name) { |n| "Ford#{n}"  }
  end
end
