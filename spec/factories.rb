FactoryGirl.define do
  factory :document do
    sequence(:name)     { |n| "Document #{n}" }
    sequence(:location) { |n| "Location #{n}"}
  end

  factory :page do
    sequence(:path) { |n| "path_#{n}.jpg"}
    document
  end
end
