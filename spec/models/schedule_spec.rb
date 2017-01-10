require 'rails_helper'

RSpec.describe Schedule, type: :model do
  it "should have a factory" do
    expect(FactoryGirl.build(:schedule)).to be_valid
  end

  context "validations" do
    it "is invalid without a date" do
      expect(FactoryGirl.build(:schedule, date: nil)).to_not be_valid
    end

    it 'is invalid without a unique date per cohort' do
      schedule = FactoryGirl.create(:schedule)
      cohort = schedule.cohort
      duplicate_schedule = cohort.schedules.build(date: schedule.date)
      expect(duplicate_schedule).to_not be_valid
    end

    it 'can duplicate dates for different cohorts' do
      schedule = FactoryGirl.create(:schedule)
      cohort = FactoryGirl.build(:cohort)
      duplicate_date = cohort.schedules.build(date: schedule.date )
      expect(duplicate_date).to be_valid
    end
  end

  describe "attributes" do
    let(:schedule) { FactoryGirl.build(:schedule) }

    it "has a date" do
      expect(schedule.date).to eq("2016-06-02 00:00:00.000000000 -0500")
    end

    it "has notes" do
      expect(schedule.notes).to eq("Today's objective include learning all of Rails and re-building Learn.co in Elixir.")
    end

    it "has a slug that is a slugified version of the schedule's date" do
      sc = Schedule.new(date: "02 Jun 2016")
      sc.cohort = FactoryGirl.build(:cohort)
      sc.save
      expect(sc.slug).to eq("jun-02-2016")
    end
  end

  context "associations" do
    let(:schedule) { FactoryGirl.build(:schedule) }
    it "has many activities" do
      activity = FactoryGirl.build(:activity)
      schedule.activities << activity
      schedule.save
      expect(schedule.activities).to include(activity)
    end

    it 'has many labs' do
      lab = FactoryGirl.build(:lab)
      schedule.labs << lab
      schedule.save
      expect(schedule.labs).to include(lab)
    end

    it 'belongs to a cohort' do
      cohort = FactoryGirl.build(:cohort)
      schedule.cohort = cohort
      expect(schedule.cohort).to eq(cohort)
    end
  end
end
