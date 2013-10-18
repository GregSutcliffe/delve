FactoryGirl.define do
  factory :document do
   sequence(:name)     { |n| "Document #{n}" }
   sequence(:location) { |n| "Location #{n}"}
  end
end
