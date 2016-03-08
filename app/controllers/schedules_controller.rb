class SchedulesController < ApplicationController
  def new
    @cohort = Cohort.find_by_name(params[:cohort_slug])
    @schedule = Schedule.new

    render "cohorts/schedules/new"
  end

  def create
    binding.pry
    # schedule = Schedule.new(schedule_params)
    # if schedule.save
    #   redirect_to schedule
    # else
    #   render :new
    # end
  end

  def show
    @schedule = Schedule.find_by(slug: params[:slug])
  end

  private
  def schedule_params
    params.require(:schedule).permit(:date, :notes, :labs => [], :activites => [:time, :description])
  end
end
