require 'rails_helper'

RSpec.describe Activity do
  describe "#execute" do 
    context "with a valid schedule and cohort" do 
      it "writes the schedule content to the README of the cohort's repo" do 
        VCR.use_cassette('deploy_schedule') do 
          schedule = FactoryGirl.create(:schedule, cohort: FactoryGirl.create(:cohort, name: "web-1115"))
          expect(ScheduleDeploymentHandler.new(schedule).execute).to eq true
        end
      end
    end

    context "with out a valid schedule and cohort" do 
      it "does not write to the github repo's README" do
        VCR.use_cassette('fail_deploy_schedule') do 
          schedule = FactoryGirl.create(:schedule)
          expect {ScheduleDeploymentHandler.new(schedule).execute}.to raise_error(Octokit::Error)
        end
      end
    end
  end
end
