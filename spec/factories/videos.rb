FactoryGirl.define do
  factory :video do
    title "Intro to Git"
    link "https://www.youtube.com/watch?v=bK7i-BMJcM0&feature=youtu.be"
    association :cohort, factory: :cohort
  end
end
