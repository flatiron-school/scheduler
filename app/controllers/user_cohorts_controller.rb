class UserCohortsController < ApplicationController


  def create
    # NOTE: There has to be a way to consolidate these instance variables into 1
    @former_active = current_user.active_cohort
    @cohort = Cohort.find(params["cohort_id"])
    @user_cohort = UserCohort.create(user_id: current_user.id, cohort_id: @cohort.id)
    @cohort = @user_cohort.cohort
    respond_to do |format|
      format.js
    end
  end

  def update
    @former_active = current_user.active_cohort
    @cohort = Cohort.find_by_name(params["id"])
    uc = UserCohort.find_by(user: current_user, cohort: @cohort)
    uc.active = true
    uc.save
     respond_to do |format|
       format.js {render 'create.js.erb'}
     end
  end
end
