class ScheduleTemplater

  TEMPLATE_FILE_PATH = Rails.root.join('app', 'templates', 'schedule.html.erb')

  def self.generate_template(schedule)
    template = Tilt.new(TEMPLATE_FILE_PATH)
    template.render(schedule, schedule: schedule)
  end
end