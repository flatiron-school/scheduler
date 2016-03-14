class Activity < ApplicationRecord
  has_many :schedule_activities
  has_many :schedules, through: :schedule_activities
  
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :description, presence: true

  def start_hour
    self.start_time.strftime("%I:%M")
  end

  def end_hour
    self.end_time.strftime("%I:%M")
  end
end
