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
      video = FactoryGirl.build(:video, link: "https://www.youtube.com/work", cohort: nil)
      cohort = FactoryGirl.build(:cohort, name: "Web-0416")
      video.cohort = cohort
      expect(video).to be_valid
    end

    it "is valid with a sharable youtube link" do
      video = FactoryGirl.build(:video, link: "https://youtu.be/bK7i-BMJcM0", cohort: nil)
      cohort = FactoryGirl.build(:cohort, name: "Web-0416")
      video.cohort = cohort
      expect(video).to be_valid
    end

    it "is invalid without a youtube link" do
      video = FactoryGirl.build(:video, link: "https://reddit.com")
      expect(video).to be_invalid
    end

    describe "#cohort" do
      it "belongs to a cohort" do
        video = FactoryGirl.build(:video, cohort: nil)
        cohort = FactoryGirl.build(:cohort, name: "Web-0416")
        video.cohort = cohort
        expect(video.cohort).to be_a(Cohort)
      end
    end
  end
end
