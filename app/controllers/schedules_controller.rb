class SchedulesController < ApplicationController
  def new
    @cohort = Cohort.find_by_name(params[:cohort_slug])
    @schedule= Schedule.new_for_form
    render "cohorts/schedules/new"
  end

  def create
    schedule = Schedule.create_from_params(schedule_params)
    schedule.build_labs(schedule_params)
    schedule.build_activities(validated_activity_params)
    if schedule.save
       cohort = Cohort.find_by_name(params[:cohort_slug])
      redirect_to cohort_schedule_path(cohort, schedule)
    else
      render 'cohorts/schedules/new'
    end
  end

  def show
    @cohort = Cohort.find_by_name(params[:cohort_slug])
    @schedule = Schedule.find_by(slug: params[:slug])
    page = render 'cohorts/schedules/show'
    GithubWrapper.new(@cohort, @schedule).update_repo_schedules(page)
  end

  private
  def schedule_params
    params.require(:schedule).permit(:week, :day, :date, :notes, :labs_attributes => [:name], :activities_attributes => [:time, :description, :reserve_room])  
  end

  def validated_activity_params
    schedule_params["activities_attributes"].delete_if {|num, activity_hash| activity_hash["time"].empty? || activity_hash["description"].empty?}
  end

end
