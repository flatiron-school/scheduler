require 'rails_helper'

RSpec.describe Activity, type: :model do
  it "should have a factory" do 
    expect(FactoryGirl.build(:activity)).to be_valid
  end

  context "validations" do 
    it "is invalid without a start time" do 
      expect(FactoryGirl.build(:activity, start_time: nil)).to_not be_valid
    end

    it 'is invalid without an end time' do 
      expect(FactoryGirl.build(:activity, end_time: nil)).to_not be_valid
    end

    it 'is invalid without a description' do 
      expect(FactoryGirl.build(:activity, description: nil)).to_not be_valid
    end
  end

  describe "attributes" do 
    let(:activity) { FactoryGirl.build(:activity) }
    
    it "has a start time" do 
      expect(activity.start_time).to eq("2000-01-01 09:00:00.000000000 -0500")
    end 

    it "has an end_time" do 
      expect(activity.end_time).to eq("2000-01-01 09:30:00.000000000 -0500")
    end

    it "has a formatted start time" do 
      expect(activity.start_hour).to eq("09:00")
    end

    it "has description" do 
      expect(activity.description).to eq("Blogs")
    end

    it "has an attribute, reserve_room, that can be true or false but defaults to false" do 
      expect(activity.reserve_room).to be false
    end
  end

  context "associations" do
    it "has many schedules" do 
      schedule = FactoryGirl.build(:schedule)
      activity = FactoryGirl.build(:activity)
      activity.schedules << schedule
      activity.save

      expect(activity.schedules).to include(schedule)
    end 
  end
end

