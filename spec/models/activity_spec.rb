require 'rails_helper'

RSpec.describe Activity, type: :model do
  it "should have a factory" do 
    expect(FactoryGirl.build(:activity)).to be_valid
  end

  context "validations" do 
    it "is invalid without a time" do 
      expect(FactoryGirl.build(:activity, time: nil)).to_not be_valid
    end

    it 'is invalid without a description' do 
      expect(FactoryGirl.build(:activity, description: nil)).to_not be_valid
    end
  end

  describe "attributes" do 
    let(:activity) { FactoryGirl.build(:activity) }
    
    it "has a time" do 
      expect(activity.time).to eq("2000-01-01 09:00:00.000000000 +0000")
    end 

    it "has a formatted time" do 
      expect(activity.hour).to eq("09:00")
    end

    it "has description" do 
      expect(activity.description).to eq("Blogs")
    end
  end

  # context "associations" do
  #   it "can have many snippets" do 
  #     user = FactoryGirl.build(:user)
  #     snippet = FactoryGirl.build(:snippet)
  #     other_snippet = FactoryGirl.build(:snippet, content: "hey")
  #     user.snippets << snippet
  #     user.snippets << other_snippet
  #     user.save!

  #     expect(user.snippets).to include(snippet)
  #     expect(user.snippets).to include(other_snippet)
  #   end 
  # end
end

