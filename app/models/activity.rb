class Activity < ApplicationRecord

  belongs_to :schedule
  
  validates :time, presence: true
  validates :description, presence: true

  def hour
    self.time.strftime("%I:%M")
  end
end
