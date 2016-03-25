module CohortsHelper

  def current_user_active_cohort(cohort)
    current_user.active_cohort == cohort
  end
end
