require 'rails_helper'

RSpec.describe Video, :type => :model do
  describe "#title" do
    it "has a title" do
      video = FactoryGirl.build(:video)
      expect(video.title).to eq("Intro to Git")
    end
  end

  describe "#link" do
    it "is valid with a youtube link" do
      video = FactoryGirl.build(:video)
      expect(video).to  be_valid
    end

    it "is valid with a sharable youtube link" do
      video = FactoryGirl.build(:video, link: "https://youtu.be/bK7i-BMJcM0")
      expect(video).to be_valid
    end

    it "is invalid without a youtube link" do
      video = FactoryGirl.build(:video, link: "https://reddit.com")
      expect(video).to be_invalid
    end
  end
end
