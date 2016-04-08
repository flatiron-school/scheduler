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
    @cohort.create_members
    @cohort.set_google_calendar_id(GoogleCalWrapper.new(current_user))
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

  private
  def cohort_params
    params.require(:cohort).permit(:name, :roster_csv, :calendar_id)
  end

  def set_cohort
    @cohort = Cohort.find_by(name: params[:slug])
  end
end
