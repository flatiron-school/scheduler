class ScheduleDeploymentHandler

  attr_accessor :schedule

  def initialize(schedule)
    @schedule = schedule
  end

  def execute
    schedule.update(deploy: true)
    schedule.deploy_to_readme(GithubWrapper.new, render_schedule_markdown)
  end

  def render_schedule_markdown
    html_string = ScheduleTemplater.generate_template(schedule)
    MarkdownConverter.convert(html_string)
  end
end