require 'rails_helper'

RSpec.describe Cohort, :type => :model do
  describe "validation" do
    it "has a name" do
      c = Cohort.new
      expect(c).to be_invalid
      expect(c.errors.full_messages).to include("Name can't be blank")
    end

    it "has a unique name" do
      Cohort.create(name: "historic")
      c = Cohort.new(name: "historic")
      expect(c).to be_invalid
      expect(c.errors.full_messages).to include("Name has already been taken")
    end

    it "name must be slugifiable aka no spaces, homie" do
      c = Cohort.new(name: "dont slug me bro")
      expect(c).to be_invalid
      expect(c.errors.full_messages).to include("Name can't contain spaces")
    end
  end

  describe "params" do
    it "sets to_params to be the slug" do
      c = Cohort.new(name: "drake")
      expect(c.to_param).to eq("drake")
    end
  end

  describe "associations" do 
    it "has many schedules" do 
      cohort = FactoryGirl.build(:cohort)
      schedule = FactoryGirl.build(:schedule)
      cohort.schedules << schedule
      expect(cohort.schedules.last).to eq(schedule)
    end
  end

end
