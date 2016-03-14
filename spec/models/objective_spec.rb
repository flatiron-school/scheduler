require 'rails_helper'

describe "Objective" do
  before(:each) do
    s = FactoryGirl.build(:schedule)
    @objective = FactoryGirl.build(:objective)
    @objective.schedule = s
  end

  describe "attributes" do
    it "has content" do
      expect(@objective.content).to eq("create a nested form")
    end
  end

  describe "associations" do
    it "belongs to a schedule" do
      expect(@objective.schedule).to be_an_instance_of(Schedule)
    end
  end
end
