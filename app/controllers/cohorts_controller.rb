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
    @cohort.set_google_calendar_id(GoogleCalWrapper.new(current_user))
    if @cohort.save
      @cohort.create_members
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
    if params[:roster_csv]
      @cohort.create_members
    end
    redirect_to @cohort
  end

  def show
    # binding.pry
    # @objectives = Objective.where()
    @weeks = @cohort.schedules.collect {|s| s.week.to_i}.sort!
    # @num_of_weeks = weeks.zip.max.first
    render :show
  end

  private

  def cohort_params
    params.require(:cohort).permit(:name, :roster_csv, :calendar_id)
  end

  def set_cohort
    @cohort = Cohort.find_by(name: params[:slug])
  end
end

