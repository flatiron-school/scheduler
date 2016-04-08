class ScheduleObjectivesController < ApplicationController

  before_action :set_cohort_and_schedule

  def remove_objective
    Objective.find(params[:objective_id]).destroy
    respond_to do |format|
      format.js {render template: 'cohorts/schedules/remove_objective.js.erb'}
    end
  end

  private

    def set_cohort_and_schedule
      @cohort = Cohort.find_by_name(params[:cohort_slug])
      @schedule = @cohort.schedules.find_by(slug: params[:slug])
    end
end
