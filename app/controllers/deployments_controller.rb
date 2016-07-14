class DeploymentsController < ApplicationController

  before_action :set_schedule

  def create
   ScheduleDeploymentHandler.new(@schedule).execute
    respond_to do |format|
      format.js {render template: 'cohorts/schedules/deploy.js.erb'}
    end
  end

  private

    def set_schedule
      @schedule = Schedule.find(params[:schedule_id])
    end
end