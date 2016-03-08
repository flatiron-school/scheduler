require 'rails_helper'

RSpec.describe Schedule, type: :model do
  it "should have a factory" do 
    expect(FactoryGirl.build(:schedule)).to be_valid
  end

  context "validations" do 
    it "is invalid without a date" do 
      expect(FactoryGirl.build(:schedule, date: nil)).to_not be_valid
    end
  end

  describe "attributes" do 
    let(:schedule) { FactoryGirl.build(:schedule) }
    
    it "has a date" do 
      expect(schedule.date).to eq("02 Jun 2016")
    end 

    it "has notes" do 
      expect(schedule.notes).to eq("Today's objective include learning all of Rails and re-building Learn.co in Elixir.")
    end

    it "has a list of labs in an array" do 
      expect(schedule.labs).to eq(["making-everything-in-rails", "elixir-code-along-2"])
    end
  end

  context "associations" do
    it "can have many activities" do 
      schedule = FactoryGirl.build(:schedule)
      activity = FactoryGirl.build(:activity)
      schedule.activities << activity
      schedule.save
      expect(schedule.activities).to include(activity)
    end 
  end
end

