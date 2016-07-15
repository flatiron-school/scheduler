require Rails.root.join('spec', 'support', 'shared_contexts', 'rake.rb')
describe "cron:deploy_schedule" do
  include_context 'rake'
  let!(:schedule) {FactoryGirl.create(:schedule, deployed_on: nil, date: Date.today, cohort: FactoryGirl.create(:cohort, name: "web-1115"))}
  let!(:deployer) { ScheduleDeploymentHandler.new(schedule) }
  it "deploys the daily schedule to GitHub" do
    VCR.use_cassette("deploy_schedule") do 
      expect(ScheduleDeploymentHandler).to receive(:new).with(schedule).and_return(deployer)
      expect(deployer).to receive(:execute)
      subject.invoke
    end
  end
end

