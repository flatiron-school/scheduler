FactoryGirl.define do
  factory :lab do
    name "learn-all-the-elixir"
    association :schedule, factory: :schedule
  end
end
