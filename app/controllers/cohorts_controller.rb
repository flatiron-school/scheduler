class CohortsController < ApplicationController
  def new
    @cohort = Cohort.new
  end

  def create
    cohort = Cohort.new(cohort_params)
    if cohort.save
      redirect_to cohort
    else
      render :new
    end
  end

  def show
    @cohort = Cohort.find_by_name(params[:slug])
  end

  private
  def cohort_params
    params.require(:cohort).permit(:name)
  end
end
