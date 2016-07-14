class ScheduleDeployer

  def deploy_daily_schedules
     ScheduleDeploymentHandler.new(schedule_to_deploy).execute if schedule_to_deploy
  end

  def schedule_to_deploy
    Schedule.where("deployed_on = NULL AND date = ?", Date.today)
  end


end
