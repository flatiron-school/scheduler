class Schedule < ApplicationRecord
  has_many :activities
  has_many :labs
  validates :date, presence: true

  before_create :slugify

  def slugify
    self.slug = self.date.strftime("%b %d, %Y").downcase.gsub(/[\s,]+/, '-') 
  end
end
