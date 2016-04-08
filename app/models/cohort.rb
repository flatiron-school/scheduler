require 'csv'
class Cohort < ApplicationRecord


  has_many :schedules
  has_many :user_cohorts
  has_many :users, through: :user_cohorts
  has_many :students
  has_many :videos
  #ugly val
  # validates_uniqueness_of :name
  #sexy val
  validates :name, uniqueness: true, presence: true, format: {with: /\A\S+\z/, message: "can't contain spaces"}

  has_attached_file :roster_csv, :path => ":rails_root/public/system/rosters/:filename"
  validates_attachment :roster_csv, content_type: { content_type: ["text/csv", "text/comma-separated-values"] }
  validates_attachment_file_name :roster_csv, :matches => [/csv\Z/]

  # after_save :create_members



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

  def set_google_calendar_id(calendar)
    id = calendar.get_cohort_calendar_id(self)
    self.update(calendar_id: id)
  end

end
