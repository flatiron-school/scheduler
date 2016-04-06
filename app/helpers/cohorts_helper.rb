module CohortsHelper
  # NOTE: Why not current_user.active_cohort?(cohort) in the model?
  def current_user_active_cohort(cohort)
    current_user.active_cohort == cohort
  end

  def current_user_owns_cohort(cohort)
    cohort.users.include?(current_user)
  end

  def is_not_active_cohort(cohort)
    current_user.active_cohort != cohort
  end
end
