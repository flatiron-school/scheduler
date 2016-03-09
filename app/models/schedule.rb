class Schedule < ApplicationRecord
  has_many :schedule_labs
  has_many :schedule_activities
  has_many :activities, through: :schedule_activities
  has_many :labs, through: :schedule_labs
  belongs_to :cohort
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

  def self.create_from_params(schedule_params, cohort)
    Schedule.new(week: schedule_params["week"], 
      day: schedule_params["day"], 
      date: schedule_params["date"], 
      notes: schedule_params["notes"],
      cohort: cohort)
  end

  def build_labs(valided_labs_params)
    valided_labs_params.each do |num, lab_hash|
      lab = Lab.find_by(name: lab_hash["name"]) || Lab.new(name: lab_hash["name"])
      self.labs << lab
    end
  end

  def build_activities(validated_activity_params)
    validated_activity_params.each do |num, activity_hash|
      activity = Activity.find_by(time: activity_hash["time"], description: activity_hash["description"]) || Activity.new(time: activity_hash["time"], description: activity_hash["description"])
      self.activities << activity
    end
  end

  def update_from_params(schedule_params)
    self.update(week: schedule_params["week"], day: schedule_params["day"], date: schedule_params["date"], notes: schedule_params["notes"])
  end

  def update_labs(schedule_params)
    schedule_params["labs_attributes"].each do |num, lab_hash|
      lab = Lab.find(lab_hash[:id])
      lab.update(lab_hash)
      lab.save
    end
  end

  def update_activities(schedule_params)
    schedule_params["activities_attributes"].each do |num, activity_hash|
      activity = Activity.find(activity_hash[:id])
      activity.update(activity_hash)
      activity.save
    end
  end

  def pretty_date
    self.date.strftime("%A, %d %b %Y")
  end
end














