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
      html_string = render_schedule_template
      MarkdownConverter.convert(html_string)
    end

    def render_schedule_template
      view = ActionView::Base.new(ActionController::Base.view_paths, {})
      view.assign(schedule: @schedule)
      view.render(file: 'cohorts/schedules/github_show.html.erb') 
    end


    def set_schedule
      @schedule = Schedule.find(params[:schedule_id])
    end
end