class CohortsController < ApplicationController
  def new
    @cohort = Cohort.new
  end

  def create
    c = Cohort.new(cohort_params)
    if c.save
      redirect_to c
    else
      render :new
    end
  end

  def show

  end

  private
  def cohort_params
    params.require(:cohort).permit(:name)
  end
end
