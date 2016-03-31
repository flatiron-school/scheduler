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

  def edited?(activity_hash)
    !(self.start_time == activity_hash["start_time"] && self.end_time == activity_hash["end_time"] && self.description == activity_hash["description"] && self.reserve_room == activity_hash["reserve_room"])
  end
end

