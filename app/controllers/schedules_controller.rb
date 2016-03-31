class SchedulesController < ApplicationController

  before_action :set_cohort_and_schedule, except: [:create, :index, :new]
  before_action :set_cohort, only: [:create, :index, :new]
  before_action :set_github_wrapper, only: [:deploy, :update]

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
    @schedule.build_objectives(validated_objectives_params)
    @schedule.get_blogs
    if @schedule.save
      set_github_wrapper
      create_schedule_on_github
      redirect_to cohort_schedule_path(@cohort, @schedule)
    else
      render 'cohorts/schedules/new'
    end
  end

  def edit
    render 'cohorts/schedules/edit'
  end

  def show
    render 'cohorts/schedules/show'
  end


  def update
    @schedule.update_from_params(schedule_params)
    if @schedule.save
      update_schedule_on_github
      redirect_to cohort_schedule_path(@schedule.cohort, @schedule)
    else
      render 'cohorts/schedules/edit'
    end
  end


  def deploy
    @schedule.deploy = true
    @schedule.save
    deploy_schedule_to_readme
    respond_to do |format|
      format.js {render template: 'cohorts/schedules/deploy.js.erb'}
    end
  end

  def reserve_rooms
    configure_google_calendar_client
    @calendar.book_events(@schedule)
    respond_to do |format|
      format.js {render template: 'cohorts/schedules/reserve_rooms.js.erb'}
    end

  end

  private
  def schedule_params
    params.require(:schedule).permit(:week, :day, :date, :notes, :deploy, :labs_attributes => [:id, :name], :activities_attributes => [:id, :start_time, :end_time, :description, :reserve_room], :objectives_attributes => [:id, :content])
  end

  def validated_activity_params
    schedule_params["activities_attributes"].delete_if {|num, activity_hash| activity_hash["start_time"].empty? || activity_hash["description"].empty? || activity_hash["end_time"].empty?}
  end

  def validated_labs_params
    schedule_params["labs_attributes"].delete_if {|num, lab_hash| lab_hash["name"].empty?}
  end

  def validated_objectives_params
    schedule_params["objectives_attributes"].delete_if {|num, obj_hash| obj_hash["content"].empty?}
  end

  def create_schedule_on_github
    @github_wrapper.create_repo_schedules
  end

  def update_schedule_on_github
    @github_wrapper.update_repo_schedules
  end

  def deploy_schedule_to_readme
    @github_wrapper.update_readme
  end

  def render_schedule_template
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    view.assign(schedule: @schedule)
    view.render(file: 'cohorts/schedules/github_show.html.erb') 
  end

  def set_cohort_and_schedule
    @cohort = Cohort.find_by_name(params[:cohort_slug])
    @schedule = @cohort.schedules.find_by(slug: params[:slug])
  end

  def set_cohort
    @cohort = Cohort.find_by_name(params[:cohort_slug])
  end

  def configure_google_calendar_client
    @calendar = GoogleCalWrapper.new(current_user)
  end

  def set_github_wrapper
    page = render_schedule_template
    @github_wrapper = GithubWrapper.new(@schedule.cohort, @schedule, page)
  end

end
