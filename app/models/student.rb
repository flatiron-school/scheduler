class Student < ApplicationRecord
  belongs_to :cohort
  has_many :blog_assignments

  def self.find_or_create_from_row(params)
    cols = self.columns.map {|col| col.name}
    params.delete_if {|key| !cols.include?(key)}
    self.find_or_create_by(params)
  end

  def full_name
    "#{self.first_name} #{self.last_name}" 
  end

  def update_blog_url(assignment)
    if self.blog_url != assignment["user"]["blog"]["url"]
    self.update(blog_url: assignment["user"]["blog"]["url"])
  end
end
