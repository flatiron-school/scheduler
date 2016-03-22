class CohortsController < ApplicationController

  before_action :set_cohort, only: [:edit, :show, :update]

  def index
    @cohorts = Cohort.all
  end
  def new
    @cohort = Cohort.new
  end

  def create
    @cohort = Cohort.new(cohort_params)
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
    redirect_to @cohort
  end

  def show
    render :show
  end

  private
  def cohort_params
    params.require(:cohort).permit(:name)
  end

  def set_cohort
    @cohort = Cohort.find_by_name(params[:slug])
  end

  def configure_google_calendar_client
    @calendar = GoogleCalWrapper.new(current_user)
  end
end
