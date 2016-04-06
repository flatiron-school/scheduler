class CohortsController < ApplicationController

  before_action :set_cohort, only: [:edit, :show, :update]
  before_action :configure_google_calendar_client, only: [:create]

  def index
    @cohorts = Cohort.all
  end
  def new
    @cohort = Cohort.new
  end

  def create
    @cohort = Cohort.new(cohort_params)
    @cohort.create_members
    # FIXME:
    # 1. Hard to know where @calendar came from. The before action doesn't
    #    suggest the definition of an instance variable.
    # 2. I'd push this into the @cohort model and try to maintain 1 instance
    #    variable per controller action.
    #    ```
    #    @cohort.get_cohort_calendar_id_for(GoogleCalWrapper.new(current_user))
    #    ```
    #    That would use dependency injection to inject the GoogleCalWrapper into
    #    the cohort when needed and then allows you to avoid @calendar.
    #    If the view needs a calendar cal wrapper (@calendar was an instance var)
    #    I would have that be a property of @cohort set in get_cohort_calendar_id_for
    #    and read from that.
    cal_id = @calendar.get_cohort_calendar_id(@cohort)
    @cohort.calendar_id = cal_id
    if @cohort.save
      redirect_to @cohort
    else
      render :new
    end
  end

  def edit
    render :edit
  end

  def update
    @cohort.update(cohort_params)
    @cohort.create_members
    redirect_to @cohort
  end

  def show
    render :show
  end

  def get_blog_schedule
    # FIXME: You can't rely on a localhost implementation and this should be a
    #        an API Wrapper object.
    response = HTTParty.get("http://localhost:8080/api/cohorts/#{@cohort.name}/schedules")
  end

  private
  def cohort_params
    params.require(:cohort).permit(:name, :roster_csv, :calendar_id)
  end

  def set_cohort
    @cohort = Cohort.find_by(:name => params[:slug])
  end

  def configure_google_calendar_client
    @calendar = GoogleCalWrapper.new(current_user)
  end
end
