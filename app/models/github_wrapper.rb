class GithubWrapper

  attr_accessor :client, :schedule, :markdown_content, :repo_name, :error

  def initialize
    configure_client
  end

  def configure_client
    @client ||= Octokit::Client.new(:access_token => ENV['OCTO_TOKEN'])
  end

  def create_schedule_in_repo(schedule, markdown_content)
    self.client.create_contents("learn-co-curriculum/#{schedule.cohort.name}", 
      "week-#{schedule.week}/day-#{schedule.day}.md", 
      "add week-#{schedule.week}/day-#{schedule.day}.md", 
      markdown_content)
  end

  def update_schedule_in_repo(schedule, markdown_content)
    sha = self.client.contents("learn-co-curriculum/#{schedule.cohort.name}", path: "week-#{schedule.week}/day-#{schedule.day}.md").sha
    self.client.update_contents("learn-co-curriculum/#{schedule.cohort.name}", 
      "week-#{schedule.week}/day-#{schedule.day}.md", 
      "update week-#{schedule.week}/day-#{schedule.day}.md",
      sha, 
      markdown_content)
  end

  def update_readme(schedule, markdown_content)
    sha = self.client.readme("learn-co-curriculum/#{schedule.cohort.name}").sha
    begin 
      self.client.update_content("learn-co-curriculum/#{schedule.cohort.name}", 
        "README.md", 
        "week-#{schedule.week}/day-#{schedule.day}.md",
        sha,
        markdown_content)
    rescue Exception => e
      @error =  e
      return  
    end
  end
end