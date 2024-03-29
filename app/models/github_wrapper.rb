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

  def update_readme(schedule, markdown_content)
    begin
      sha = self.client.readme("learn-co-curriculum/#{schedule.cohort.name}").sha
      self.client.update_content("learn-co-curriculum/#{schedule.cohort.name}",
        "README.md",
        "week-#{schedule.week}/day-#{schedule.day}.md",
        sha,
        markdown_content)
    rescue Exception => e
      raise e
    end
  end

  def update_videos_content(video, markdown_content)
    sha = self.client.contents("learn-co-curriculum/#{video.cohort.name}", path: "videos/links.md").sha
    self.client.update_contents("learn-co-curriculum/#{video.cohort.name}", "videos/links.md", "updating video content", sha, markdown_content)
  end


  def update_schedule_in_repo(schedule, markdown_content)
    if !!schedule_exists_in_repo(schedule)
      if schedule.week_changed? || schedule.day_changed?
        delete_schedule_in_repo(schedule)
        binding.pry
        !!schedule_does_not_exist_in_repo(schedule) ? create_schedule_in_repo(schedule, markdown_content) : update_schedule_file(schedule, markdown_content)
      else
        update_schedule_file(schedule, markdown_content)
      end
    else
      create_schedule_in_repo(schedule, markdown_content)
    end
  end

  private

    def schedule_does_not_exist_in_repo(schedule)
      begin 
        self.client.contents("learn-co-curriculum/#{schedule.cohort.name}", path: "week-#{schedule.week}/day-#{schedule.day}.md")
      rescue Exception => e
        return true
      end
    end

    def schedule_exists_in_repo(schedule)
      begin 
        self.client.contents("learn-co-curriculum/#{schedule.cohort.name}", path: "week-#{schedule.week_was}/day-#{schedule.day_was}.md")
      rescue Exception => e
        return false
      end
    end

    def delete_schedule_in_repo(schedule)
      sha = self.client.contents("learn-co-curriculum/#{schedule.cohort.name}", path: "week-#{schedule.week_was}/day-#{schedule.day_was}.md").sha
      self.client.delete_contents("learn-co-curriculum/#{schedule.cohort.name}",
        "week-#{schedule.week_was}/day-#{schedule.day_was}.md",
        "delete #{schedule.week_was}/#{schedule.day_was}",
        sha)
    end

    def update_schedule_file(schedule, markdown_content)
      sha = self.client.contents("learn-co-curriculum/#{schedule.cohort.name}", path: "week-#{schedule.week}/day-#{schedule.day}.md").sha
      self.client.update_contents("learn-co-curriculum/#{schedule.cohort.name}", 
        "week-#{schedule.week}/day-#{schedule.day}.md", 
        "update week-#{schedule.week}/day-#{schedule.day}.md",
        sha, 
        markdown_content)
    end

end
