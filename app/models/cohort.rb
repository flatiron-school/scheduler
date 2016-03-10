class Cohort < ApplicationRecord

  has_many :schedules
  has_many :user_cohorts
  has_many :users, through: :user_cohorts
  #ugly val
  # validates_uniqueness_of :name
  #sexy val
  validates :name, uniqueness: true, presence: true, format: {with: /\A\S+\z/, message: "can't contain spaces"}

  def to_param
    self.name
  end

end
