class GithubWrapper

  attr_accessor :client, :schedule, :markdown_content, :repo_name, :error

  def initialize(cohort, schedule, page)
    configure_client
    @repo_name = "learn-co-curriculum/#{cohort.name}"
    @schedule = schedule
    schedule_template_content = page.split("<h1>").second.prepend("<h1>").split("</body>").first
    @markdown_content = ReverseMarkdown.convert(schedule_template_content)
  end

  def create_repo_schedules
    create_schedule_in_repo
    update_readme
  end

  def update_repo_schedules
    update_schedule_in_repo
    update_readme
  end

  def configure_client
    @client ||= Octokit::Client.new(:access_token => ENV['OCTO_TOKEN'])
  end

  def create_schedule_in_repo
    created_content = self.client.create_contents(repo_name, 
      "week-#{self.schedule.week}/day-#{schedule.day}.md", 
      "add week-#{schedule.week}/day-#{schedule.day}.md", 
      markdown_content)
    self.schedule.sha = created_content[:content][:sha]
    self.schedule.save
  end

  def update_schedule_in_repo
    sha = self.client.contents(repo_name, path: "week-#{self.schedule.week}/day-#{self.schedule.day}.md").sha
    puts "HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    puts sha
    self.client.update_contents(repo_name, 
      "week-#{self.schedule.week}/day-#{self.schedule.day}.md", 
      "update week-#{self.schedule.week}/day-#{self.schedule.day}.md",
      sha, 
      markdown_content)
  end

  def update_readme
    if self.schedule.deploy
      sha = self.client.readme(repo_name)[:sha]
      puts sha
      begin 
        self.client.update_content(repo_name, 
          "README.md", 
          "week-#{self.schedule.week}/day-#{self.schedule.day}.md",
          sha,
          markdown_content)
      rescue Exception => e
        @error =  e
        return  
      end
      self.schedule.deployed_on = Date.today
      self.schedule.save
    end
  end
end