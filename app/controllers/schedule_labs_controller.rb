class ScheduleLabsController < ApplicationController

  before_action :set_cohort_and_schedule

  def remove_lab
    schedule_lab = ScheduleLab.find_by(schedule: @schedule, lab: Lab.find(params[:lab_id]))
    schedule_lab.destroy
    respond_to do |format|
      format.js {render template: 'cohorts/schedules/remove_lab.js.erb'}
    end
  end

  private

    def set_cohort_and_schedule
      @cohort = Cohort.find_by_name(params[:cohort_slug])
      @schedule = @cohort.schedules.find_by(slug: params[:slug])
    end
end
