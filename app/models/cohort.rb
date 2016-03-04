class Cohort < ApplicationRecord
  #ugly val
  # validates_uniqueness_of :name
  #sexy val
  validates :name, uniqueness: true, presence: true, format: {with: /\A\S+\z/, message: "can't contain spaces"}

  def to_param
    self.name
  end
end
