FactoryGirl.define do
  factory :document do
    sequence(:name)     { |n| "Document #{n}" }
    sequence(:location) { |n| "Location #{n}"}
  end

  factory :page do
    sequence(:path) { |n| "path_#{n}.jpg"}
    document

    trait :unassociated do
      before :create do |page|
        page.document_id = nil
      end
    end
  end

  factory :scanner do
    sequence(:name)       { |n| "scanner #{n}" }
    sequence(:device_url) { |n| "net://foo#{n}/bar" }
  end
end
