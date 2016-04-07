class WebhooksController < ApplicationController
  before_action :set_cohort, only: [:event_listener]
  # before_action :set_github_wrapper, only: [:event_listener]

  skip_before_filter :verify_authenticity_token, only: [:event_listener]
  skip_before_filter :authenticate_user!, only: [:event_listener]

  def event_listener
    binding.pry
    if params["zen"]
      head :no_content 
      return 
    else
      params[:commits].each do |commit|
        if modified_file?(commit)
          update_item(commit)
        end
      end
    end
  end

  def added_file?(commit)
    !commit["added"].empty?
  end

  def removed_file?(commit)
    !commit["removed"].empty?
  end

  def modified_file?(commit)
    !commit["modified"].empty?
  end

  def update_item(commit)
    commit["modified"].each do |file_name| 
      schedule_week =  file_name.split("/").first
      schedule_day = file_name.split("/").last.split(".").first
      @schedule = Schedule.find_by(cohort: @cohort, week: schedule_week, day: schedule_day)
      set_github_wrapper
      contents = @github_wrapper.get_file_contents(file_name)
      github_content_parser = GithubContentParser.new(contents)
      github_content_parser.parse_content

    end
  end

  private

    def set_cohort
      @cohort = Cohort.find_by(name: params[:cohort_slug])
    end

    def set_github_wrapper
      @github_wrapper = GithubWrapper.new(@cohort, @schedule)
    end

end