class ScheduleLabsController < ApplicationController

  before_action :set_cohort_and_schedule

  def remove_lab
    # NOTE: The 3 instance variables and objects to destroy 1 object feels weird.
    # ScheduleLab.destroy_by_cohort_and_slug(params[:cohort_slug], params[:slug])
    # maybe something like that and then just use params[:lab_id] in JS view?
    @lab = Lab.find(params[:lab_id])
    schedule_lab = ScheduleLab.find_by(schedule: @schedule, lab: @lab)
    schedule_lab.destroy
    respond_to do |format|
      # NOTE: What's render template vs render 'view' :layout => false
      #       Though I think js templates automatically render sans layout.
      format.js {render template: 'cohorts/schedules/remove_lab.js.erb'}
    end
  end

  private

    def set_cohort_and_schedule
      @cohort = Cohort.find_by_name(params[:cohort_slug])
      @schedule = @cohort.schedules.find_by(slug: params[:slug])
    end
end
