class DeploymentsController < ApplicationController

  before_action :set_schedule

  def create
    @schedule.update(deploy: true)
    @schedule.deploy_to_readme(GithubWrapper.new, render_schedule_markdown)
    respond_to do |format|
      format.js {render template: 'cohorts/schedules/deploy.js.erb'}
    end
  end

  private

    def render_schedule_markdown
      html_string = ScheduleTemplater.generate_template(@schedule)
      MarkdownConverter.convert(html_string)
    end

    def set_schedule
      @schedule = Schedule.find(params[:schedule_id])
    end
end