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
  before_save :check_deploy

  def slugify
    self.slug = self.date.strftime("%b %d, %Y").downcase.gsub(/[\s,]+/, '-')
  end

  def to_param
    self.slug
  end

  def check_deploy
    if self.deploy
      prev_deployed_schedule = Schedule.find_by(deploy: true)
      prev_deployed_schedule.update(deploy: false) if prev_deployed_schedule && prev_deployed_schedule != self
    end
  end

  def build_labs(schedule_data)
    validated_schedule_labs_data(schedule_data).each do |num, lab_hash|
      lab = Lab.find_by(name: lab_hash["name"]) || Lab.new(name: lab_hash["name"])
      ScheduleLab.create(lab: lab, schedule: self)
    end
  end

  def build_activities(schedule_data)
    validated_schedule_activities_data(schedule_data).each do |num, activity_hash|
      activity = Activity.find_by(start_time: activity_hash["start_time"], end_time: activity_hash["end_time"], description: activity_hash["description"], reserve_room: activity_hash["reserve_room"]) || Activity.new(start_time: activity_hash["start_time"], end_time: activity_hash["end_time"], description: activity_hash["description"], reserve_room: activity_hash["reserve_room"])
      ScheduleActivity.create(activity: activity, schedule: self)
    end
  end

  def build_objectives(schedule_data)
   validated_objectives_data(schedule_data).each do |num, objective_hash|
      objective = Objective.find_by(content: objective_hash[:content]) || Objective.new(content: objective_hash[:content])
      objective.update(schedule: self)
      binding.pry
    end
  end

   def validated_schedule_labs_data(schedule_data)
    schedule_data["labs_attributes"].delete_if {|num, lab_hash| lab_hash["name"].empty?}
  end

  def validated_schedule_activities_data(schedule_data)
    schedule_data["activities_attributes"].delete_if {|num, activity_hash| activity_hash["start_time"].empty? || activity_hash["description"].empty? || activity_hash["end_time"].empty?}
  end

  def validated_objectives_data(schedule_data)
    schedule_data["objectives_attributes"].delete_if {|num, obj_hash| obj_hash["content"].empty?}

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
        if assignment["user"]["blog"] && student
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


  def create_schedule_on_github(client, markdown_content)
    response = client.create_schedule_in_repo(self, markdown_content)
    self.update(sha: response.content.sha)
    client.deploy_to_readme(client, markdown_content) if self.deploy
  end

  def update_schedule_on_github(client, markdown_content)
    client.update_schedule_in_repo(self, markdown_content)
    client.deploy_to_readme(self, markdown_content) if self.deploy
  end

  def deploy_to_readme(client, markdown_content)
    client.update_readme(self, markdown_content)
    self.update(deployed_on: Date.today)
  end
end
