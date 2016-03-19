FactoryGirl.define do
  factory :activity do
    start_time "9:00"
    end_time "9:30"
    description "Blogs"
    reserve_room false
  end
end
