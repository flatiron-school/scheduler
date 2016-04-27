class Video < ApplicationRecord
  belongs_to :cohort

  validates :title, presence: true
  validates :link, uniqueness: true, presence: true, format: {with: /https:\/\/youtu.be\/|https:\/\/www.youtube.com/, message: "must be a valid youtube link"}


  def video_error
    error_string = ""
    self.errors.messages.each do |error, message|
      error_string << "#{error.capitalize}: " + message[0] + " "
    end
    error_string
  end

  def update_videos_on_github(client, markdown_content)
    client.update_videos_content(self, markdown_content)
  end
end
