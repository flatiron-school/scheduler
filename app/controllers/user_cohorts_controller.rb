class UserCohortsController < ApplicationController


  def create
    @user_cohort = UserCohort.create(user_id: current_user.id, cohort_id: params[:cohort_id])
    @cohort = @user_cohort.cohort
    respond_to do |format|
      format.js
    end
  end

  # def destroy
  #   @cohort = Cohort.find_by_name(params["id"])
  #   uc = UserCohort.find_by(user: current_user, cohort: @cohort)
  #   uc.destroy
  #   respond_to do |format|
  #     format.js {render 'create.js.erb'}
  #   end
  # end

  def update
    @cohort = Cohort.find_by_name(params["id"])
    uc = UserCohort.find_by(user: current_user, cohort: @cohort)
    uc.active = true
    uc.save
  end
end