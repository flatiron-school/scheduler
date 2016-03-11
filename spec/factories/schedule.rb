FactoryGirl.define do
  factory :schedule do
    date "02 Jun 2016"
    notes "Today's objective include learning all of Rails and re-building Learn.co in Elixir."
    created_at Date.today
    updated_at Date.today
    association :cohort, factory: :cohort
  end
end