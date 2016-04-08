class ScheduleActivitiesController < ApplicationController

  before_action :set_cohort_and_schedule

  def remove_activity
    schedule_activity = ScheduleActivity.find_by(schedule: @schedule, activity: Activity.find(params[:activity_id]))
    schedule_activity.destroy
    respond_to do |format|
      format.js {render template: 'cohorts/schedules/remove_activity.js.erb'}
    end
  end

  private

    def set_cohort_and_schedule
      @cohort = Cohort.find_by_name(params[:cohort_slug])
      @schedule = @cohort.schedules.find_by(slug: params[:slug])
    end
end
