require 'csv'
class Cohort < ApplicationRecord


  has_many :schedules
  has_many :user_cohorts
  has_many :users, through: :user_cohorts
  has_many :students
  #ugly val
  # validates_uniqueness_of :name
  #sexy val
  validates :name, uniqueness: true, presence: true, format: {with: /\A\S+\z/, message: "can't contain spaces"}

  has_attached_file :roster_csv
  validates_attachment :roster_csv, content_type: { content_type: ["text/csv", "text/comma-separated-values"] }
  validates_attachment_file_name :roster_csv, :matches => [/csv\Z/]
  # after_create :create_members
  # after_update :create_members

  def to_param
    self.name
  end


  def create_members
    return if !roster_csv.path
    CSV.foreach(roster_csv.path, headers: true).each do |student_row|
      self.students.find_or_create_from_row(student_row.to_h)
      # FIXME: Avoid << on associations, it's tremendously ineffecient.
      self.students << student
    end
  end



end
