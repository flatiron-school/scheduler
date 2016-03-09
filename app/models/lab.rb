class Lab < ApplicationRecord
  has_many :schedule_labs
  has_many :schedule, through: :schedule_lab
  validates :name, uniqueness: true, presence: true, format: {with: /\A\S+\z/, message: "can't contain spaces"}
end
