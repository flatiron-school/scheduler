class ScheduleDeployer

  def self.deploy_daily_schedule
    ScheduleDeploymentHandler.new(schedule_to_deploy).execute if schedule_to_deploy
  end

  def self.schedule_to_deploy
    Schedule.where(deployed_on: nil).where(date: Date.today.beginning_of_day).first
  end


end


namespace :cron do 
  desc "Deploy the daily schedule"
  task :deploy_schedule => :environment do 
    ScheduleDeployer.deploy_daily_schedule
  end
end