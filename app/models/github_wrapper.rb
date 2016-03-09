class GithubWrapper

  attr_accessor :client, :schedule, :cohort, :markdown_content

  def initialize(cohort, schedule)
    configure_client
    @cohort = cohort
    @schedule = schedule
  end

  def update_repo_schedules(page)
    create_schedule_in_repo(page)
    update_readme
  end

  def configure_client
    @client ||= Octokit::Client.new(:access_token => ENV['OCTO_TOKEN'])
  end

  def create_schedule_in_repo(page)
    schedule_template_content = page.split("<h1>").second.prepend("<h1>").split("</body>").first
    @markdown_content = ReverseMarkdown.convert(schedule_template_content)
    self.client.create_contents("learn-co-curriculum/#{cohort.name}", 
      "week-#{self.schedule.week}/day-#{self.schedule.day}.md", 
      "create contributing", 
      markdown_content)
  end

  def update_readme
    sha = self.client.readme("learn-co-curriculum/#{self.cohort.name}")[:sha]
    self.client.update_content("learn-co-curriculum/#{self.cohort.name}", 
      "README.md", 
      "week-#{self.schedule.week}/day-#{self.schedule.day}.md",
      sha,
      @markdown_content)
  end
end