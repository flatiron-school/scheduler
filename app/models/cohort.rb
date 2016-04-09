require 'csv'
class Cohort < ApplicationRecord


  has_many :schedules
  has_many :user_cohorts
  has_many :users, through: :user_cohorts
  has_many :students
  
  has_many :videos
 
  validates :name, uniqueness: true, presence: true, format: {with: /\A\S+\z/, message: "can't contain spaces"}

  has_attached_file :roster_csv, :path => ":rails_root/public/system/rosters/:filename"
  validates_attachment :roster_csv, content_type: { content_type: ["text/csv", "text/comma-separated-values"] }
  validates_attachment_file_name :roster_csv, :matches => [/csv\Z/]

  def to_param
    self.name
  end


  def create_members
    return if !roster_csv.path
    csv_rows = CSV.foreach(roster_csv.path, headers: true)
    csv_rows.each do |student_row|
      student = Student.find_or_create_from_row(student_row.to_h)
      self.students << student
    end
    self.save
  end

  def build_schedule(schedule_data)
    schedule = create_schedule(schedule_data)
    schedule.build_labs(schedule_data)
    schedule.build_activities(schedule_data)
    schedule.build_objectives(schedule_data)
    schedule.get_blogs
    schedule
  end

  def create_schedule(schedule_data)
    Schedule.new.tap do |s|
      s.day = schedule_data[:day]
      s.week = schedule_data[:week]
      s.date = schedule_data[:date]
      s.notes = schedule_data[:notes]
      s.deploy = schedule_data[:deploy]
      s.cohort = self
      s.save
    end
  end

  def set_google_calendar_id(calendar)
    id = calendar.get_cohort_calendar_id(self)
    self.update(calendar_id: id)
  end

end
