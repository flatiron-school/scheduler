class Video < ApplicationRecord
  belongs_to :cohort

  validates :title, presence: true
  validates :link, uniqueness: true, presence: true, format: {with: /https:\/\/youtu.be\/|https:\/\/www.youtube.com/, message: "must be a valid youtube link"}

end
