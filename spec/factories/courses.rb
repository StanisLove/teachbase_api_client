FactoryGirl.define do
  factory :course do
    sequence(:name) { |n| "Name #{n}" }
    sequence(:description) { |n| "Descr #{n}" }
    sequence(:owner_name) { |n| "Owner #{n}" }
    sequence(:course_id) { |n| n }
    sequence(:course_updated_at) { Time.now }
  end
end
