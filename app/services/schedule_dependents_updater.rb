class ScheduleDependentsUpdater

  def self.execute(schedule, schedule_data)
    update_labs(schedule, schedule_data)
    update_objectives(schedule, schedule_data)
    update_activities(schedule, schedule_data)
  end

  def self.update_labs(schedule, schedule_data)
    schedule_data[:labs_attributes].try(:each) do |num, lab_hash|
      if lab_hash["id"]
        lab = Lab.find(lab_hash["id"])
        if lab.edited?(lab_hash)
          sl = ScheduleLab.find_by(schedule_id: schedule.id, lab_id: lab_hash["id"])
          sl.destroy if sl
          lab = Lab.find_or_create_by(name: lab_hash["name"])
          ScheduleLab.create(lab: lab, schedule: schedule)
        end
      else
        lab = Lab.find_or_create_by(name: lab_hash["name"])
        ScheduleLab.create(lab: lab, schedule: schedule)
      end
    end
  end

  def self.update_objectives(schedule, schedule_data)
    schedule_data["objectives_attributes"].try(:each) do |num, objective_hash|
      if objective_hash["id"]
        objective = Objective.find(objective_hash["id"])
        objective.update(objective_hash)
      else
        objective = Objective.create(content: objective_hash["content"])
        ScheduleObjective.create(objective: objective, schedule: schedule)
      end
    end
  end

  def self.update_activities(schedule, schedule_data)
    schedule_data["activities_attributes"].try(:each) do |num, activity_hash|
      if activity_hash["id"]
        activity = Activity.find(activity_hash["id"])
        if activity.edited?(activity_hash)
          sa = ScheduleActivity.find_by(schedule_id: schedule.id, activity_id: activity_hash["id"])
          sa.destroy if sa
          activity_data = activity_hash.reject {|k| k == "id"}
          activity = Activity.find_or_create_by(activity_data)
          ScheduleActivity.create(activity: activity, schedule: schedule)
        end
      else
        activity = Activity.find_or_create_by(activity_hash)
        ScheduleActivity.create(activity: activity, schedule: schedule)
      end
    end
  end

  
end