class Activity < ApplicationRecord
  has_many :schedule_activities
  has_many :schedules, through: :schedule_activities
  
  validates :time, presence: true
  validates :description, presence: true

  def hour
    self.time.strftime("%I:%M")
  end
end
