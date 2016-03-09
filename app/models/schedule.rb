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
end
