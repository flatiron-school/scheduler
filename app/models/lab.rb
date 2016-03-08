class Lab < ApplicationRecord
  belongs_to :schedule
  validates :name, uniqueness: true, presence: true, format: {with: /\A\S+\z/, message: "can't contain spaces"}
end
