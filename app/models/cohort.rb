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
  validates_attachment_file_name :roster_csv, :matches => [/csv\Z/]
  attr_accessible :roster_csv_file_name
 
  def to_param
    self.name
  end

  after_save :create_members

  def create_members
    return if !roster_csv.path  
    
    csv_rows = CSV.foreach(roster_csv.path, headers: true)
    csv_rows.each do |student_row|
      student = Student.find_or_create_from_row(student_row.to_h)
      self.students << student
      self.save
    end
  end



end
