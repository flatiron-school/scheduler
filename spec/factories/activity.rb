FactoryGirl.define do
  factory :activity do
    time "9:00"
    description "Blogs"
    reserve_room false
    association :schedule, factory: :schedule
  end
end
