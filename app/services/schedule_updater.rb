class ScheduleUpdater

  def self.update(schedule, schedule_attributes_params)
    schedule.assign_attributes(schedule_attributes_params)
    schedule.update_blogs if schedule.date_changed?
  end
end