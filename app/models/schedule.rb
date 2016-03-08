class Schedule < ApplicationRecord
  has_many :activities
  validates :date, presence: true
end
