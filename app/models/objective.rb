class Objective < ApplicationRecord
  belongs_to :schedule
  delegate :week, to: :schedule
end
