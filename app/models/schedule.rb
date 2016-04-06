class Schedule < ApplicationRecord
  include HTTParty
  has_many :schedule_labs
  has_many :schedule_activities
  has_many :activities, through: :schedule_activities
  has_many :labs, through: :schedule_labs
  has_many :objectives, dependent: :destroy
  has_many :calendar_events
  has_many :blog_assignments
  belongs_to :cohort
  accepts_nested_attributes_for :labs
  accepts_nested_attributes_for :activities
  accepts_nested_attributes_for :objectives
  validates :date, presence: true

  before_create :slugify

  def slugify
    self.slug = self.date.strftime("%b %d, %Y").downcase.gsub(/[\s,]+/, '-')
  end

  def to_param
    self.slug
  end

  # FIXME: I think this can be moved into a controller and I'd avoid
  #        using <<
  #        You could also Schedule.new.tap to avoid the local
  def self.new_for_form
    schedule = Schedule.new

    3.times do
      schedule.objectives << Objective.new
    end

    3.times do
      schedule.labs << Lab.new
    end

    3.times do
      schedule.activities << Activity.new
    end

    schedule
  end

  def self.create_from_params(schedule_params, cohort)
    schedule = Schedule.new(week: schedule_params["week"],
      day: schedule_params["day"],
      date: schedule_params["date"],
      notes: schedule_params["notes"],
      deploy: schedule_params["deploy"],
      cohort: cohort)
  end

  def build_labs(valided_labs_params)
    valided_labs_params.each do |num, lab_hash|
      self.labs.where(name: lab_hash["name"]).first_or_initialize
    end
  end

  def build_activities(validated_activity_params)
    validated_activity_params.each do |num, activity_hash|
      # FIXME: Same pattern as above.
      activity = Activity.find_by(start_time: activity_hash["start_time"], end_time: activity_hash["end_time"], description: activity_hash["description"], reserve_room: activity_hash["reserve_room"]) || Activity.new(start_time: activity_hash["start_time"], end_time: activity_hash["end_time"], description: activity_hash["description"], reserve_room: activity_hash["reserve_room"])
      self.activities << activity
    end
  end

  def build_objectives(validated_objectives_params)
    validated_objectives_params.each do |num, objective_hash|
      # FIXME: Same pattern as above.
      objective = Objective.find_by(content: objective_hash[:content]) || Objective.new(content: objective_hash[:content])
      self.objectives << objective
      objective.schedule = self
    end
  end

  def update_from_params(schedule_params)
    self.update(notes: schedule_params["notes"], deploy: schedule_params["deploy"])
    # FIXME: I think you end up saving and firing a ton of un-needed SQL here.
    #        I'd consider introducing a ScheduleUpdater and ScheduleBuilder type
    #        Service object to handle the routines of updating and building schedules
    #        with all their associated data.
    self.update_labs(schedule_params)
    self.update_activities(schedule_params)
    self.update_objectives(schedule_params)
  end

  def update_labs(schedule_params)
    schedule_params["labs_attributes"].try(:each) do |num, lab_hash|
      if lab_hash["id"]
        lab = Lab.find(lab_hash["id"])
        if lab.edited?(lab_hash)
          sl = ScheduleLab.find_by(schedule_id: self.id, lab_id: lab_hash["id"])
          sl.destroy if sl
          lab = Lab.find_or_create_by(name: lab_hash["name"])
          self.labs << lab
          self.save
        end
      else
        lab = Lab.find_or_create_by(name: lab_hash["name"])
        self.labs << lab
        self.save
      end
    end
  end

  def update_activities(schedule_params)
    schedule_params["activities_attributes"].try(:each) do |num, activity_hash|
      if activity_hash["id"]
        activity = Activity.find(activity_hash["id"])
        if activity.edited?(activity_hash)
          sa = ScheduleActivity.find_by(schedule_id: self.id, activity_id: activity_hash["id"])
          sa.destroy if sa
          activity_data = activity_hash.reject {|k| k == "id"}
          activity = Activity.find_or_create_by(activity_data)
          self.activities << activity
          self.save
        end
      else
        activity = Activity.find_or_create_by(activity_hash)
        self.activities << activity
        self.save
      end
    end
  end

  def update_objectives(schedule_params)
    schedule_params["objectives_attributes"].try(:each) do |num, objective_hash|
      if objective_hash["id"]
        objective = Objective.find(objective_hash["id"])
        objective.update(objective_hash)
      else
        objective = Objective.create(content: objective_hash["content"])
        self.objectives << objective
        self.save
      end
    end
  end

  def pretty_date
    self.date.strftime("%A, %d %b %Y")
  end

  def reservation_activities
    self.activities.reject { |a| !a.reserve_room }
  end

  def deployed?
    !!self.deployed_on
  end

  def get_blogs
    assignments = retrieve_blogs_from_api
    if !assignments.empty?
      assignments["schedules"].each do |assignment|
        student = Student.find_by(first_name: assignment["user"]["first_name"], last_name: assignment["user"]["last_name"])
        if assignment["user"]["blog"]
          student.blog_url = assignment["user"]["blog"]["url"]
          student.save
        end
        blog_assignment = BlogAssignment.create(student: student, schedule: self, due_date: assignment["due_date"])
        self.blog_assignments << blog_assignment
        self.save
      end
    end
  end

  def retrieve_blogs_from_api
    HTTParty.get("#{ENV['BLOG_API_ENDPOINT']}/api/cohorts/#{self.cohort.name}/blog_assignments/#{self.date_for_api_call}")
  end

  def date_for_api_call
    self.date.strftime("%Y-%m-%d")
  end

end
