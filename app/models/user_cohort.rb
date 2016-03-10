class UserCohort < ApplicationRecord
  belongs_to :user 
  belongs_to :cohort
  before_save :reset_active

  def reset_active
    if self.active && UserCohort.where("active = ? AND user_id = ?", true, self.user.id)
      former_active = UserCohort.where("active = ? AND user_id = ?", true, self.user.id).first
      former_active.active = false
      former_active.save 
    end
  end
end
