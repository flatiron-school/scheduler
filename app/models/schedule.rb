class Schedule < ApplicationRecord
  has_many :activities
  has_many :labs
  accepts_nested_attributes_for :labs
  accepts_nested_attributes_for :activities
  validates :date, presence: true

  before_create :slugify

  def slugify
    self.slug = self.date.strftime("%b %d, %Y").downcase.gsub(/[\s,]+/, '-') 
  end

  def to_param
    self.slug
  end

  def self.new_for_form
    schedule = Schedule.new
    3.times do 
      schedule.labs << Lab.new
    end
    10.times do
      schedule.activities << Activity.new
    end
    schedule
  end

  def self.create_from_params(schedule_params)
    Schedule.new(week: schedule_params["week"], day: schedule_params["day"], date: schedule_params["date"], notes: schedule_params["notes"])
  end

  def build_labs(schedule_params)
    schedule_params["labs_attributes"].each do |num, lab_hash|
      lab = Lab.find_by(name: lab_hash["name"]) || Lab.new(name: lab_hash["name"])
      self.labs << lab
      lab.schedule = self
    end
  end

  def build_activities(validated_activity_params)
    validated_activity_params.each do |num, activity_hash|
      activity = Activity.new(time: activity_hash["time"], description: activity_hash["description"], reserve_room: activity_hash["reserve_room"])
      self.activities << activity
      activity.schedule = self
    end
  end
end
