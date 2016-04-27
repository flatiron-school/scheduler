class VideoTemplater

  TEMPLATE_FILE_PATH = Rails.root.join('app', 'templates', 'videos.html.erb')

  def self.generate_template(videos)
    template = Tilt.new(TEMPLATE_FILE_PATH)
    template.render(videos, videos: videos)
  end

end
