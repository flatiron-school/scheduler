class SchedulesController < ApplicationController

  before_action :set_cohort_and_schedule, except: [:create, :index, :new]
  before_action :set_cohort, only: [:create, :index, :new]

  def index
    @schedules = @cohort.schedules
    render 'cohorts/schedules/index'
  end

  def new
    @schedule= NewScheduleBuilder.create_empty_schedule
    render "cohorts/schedules/new"
  end

  def create
    @schedule = @cohort.build_schedule(schedule_params)
    if @schedule.save
      @schedule.create_schedule_on_github(GithubWrapper.new, render_schedule_markdown)
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
    @schedule.update(schedule_params)
    ScheduleDependentsUpdater.execute(@schedule, schedule_params)
    if @schedule.save
      @schedule.update_schedule_on_github(GithubWrapper.new, render_schedule_markdown)
      # update_schedule_on_github
      redirect_to cohort_schedule_path(@schedule.cohort, @schedule)
    else
      render 'cohorts/schedules/edit'
    end
  end

  
  def deploy
    @schedule.update(deploy: true)
    @schedule.deploy_to_readme(GithubWrapper.new, render_schedule_markdown)
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

  def render_schedule_markdown
    html_string = render_schedule_template
    MarkdownConverter.convert(html_string)
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


end
