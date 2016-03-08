require 'rails_helper'

RSpec.describe Lab, :type => :model do
  describe "#name" do 
    it 'has a name' do 
      lab = FactoryGirl.build(:lab)
      expect(lab.name).to eq("learn-all-the-elixir")
    end
  end

  describe "validations" do 
    it 'is invalid with a name with white space instead of dashes' do 
      lab = FactoryGirl.build(:lab, name: "learn all the elixir")
      expect(lab).to be_invalid
    end
  end

  describe "associations" do 
    it "belongs to a schedule" do 
      lab = FactoryGirl.build(:lab)
      schedule = FactoryGirl.build(:schedule)
      schedule.labs << lab
      schedule.save

      expect(schedule.labs).to include(lab)
      expect(lab.schedule).to eq(schedule)
    end
  end
end
