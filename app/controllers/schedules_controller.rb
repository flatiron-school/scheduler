class SchedulesController < ApplicationController

  before_action :set_cohort_and_schedule, except: [:create, :index, :new]
  before_action :set_cohort, only: [:create, :index, :new]

  def index
    @schedules = @cohort.schedules
    render 'cohorts/schedules/index'
  end

  def new
    @schedule= Schedule.new_for_form
    render "cohorts/schedules/new"
  end

  def create
    @schedule = Schedule.create_from_params(schedule_params, @cohort)
    @schedule.build_labs(validated_labs_params)
    @schedule.build_activities(validated_activity_params)
    if @schedule.save
      redirect_to cohort_schedule_path(@cohort, @schedule)
    else
      render 'cohorts/schedules/new'
    end
  end
  
  def edit
    render 'cohorts/schedules/edit'
  end

  def show
    page = render 'cohorts/schedules/show'
    if creating_schedule
      GithubWrapper.new(@schedule.cohort, @schedule, page).create_repo_schedules
    elsif updating_schedule
      GithubWrapper.new(@schedule.cohort, @schedule, page).update_repo_schedules
    end
  end


  def update
    @schedule.update_from_params(schedule_params)
    @schedule.update_labs(schedule_params)
    @schedule.update_activities(schedule_params)
    if @schedule.save
      redirect_to cohort_schedule_path(@schedule.cohort, @schedule)
    else
      render 'cohorts/schedules/edit'
    end
  end

  private
  def schedule_params
    params.require(:schedule).permit(:week, :day, :date, :notes, :deploy, :labs_attributes => [:id, :name], :activities_attributes => [:id, :time, :description, :reserve_room])  
  end

  def validated_activity_params
    schedule_params["activities_attributes"].delete_if {|num, activity_hash| activity_hash["time"].empty? || activity_hash["description"].empty?}
  end

  def validated_labs_params
    schedule_params["labs_attributes"].delete_if {|num, lab_hash| lab_hash["name"].empty?}
  end

  def creating_schedule
    request.referrer.split("/").last == "new"
  end

  def updating_schedule
    request.referrer.split("/").last == "edit"
  end

  def set_cohort_and_schedule
    @cohort = Cohort.find_by_name(params[:cohort_slug])
    @schedule = @cohort.schedules.find_by(slug: params[:slug])
  end

  def set_cohort
    @cohort = Cohort.find_by_name(params[:cohort_slug])
  end

end
