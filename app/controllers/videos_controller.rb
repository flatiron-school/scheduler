class VideosController < ApplicationController

  def create
    @video = Video.new(video_params)
    @video.cohort = current_user.active_cohort
    if @video.save
      respond_to do |format|
        format.html {}
        format.js {}
      end
    else
      render :js => 'alert("' + @video.video_error + '")'
    end
    @video.update_videos_on_github(GithubWrapper.new, render_schedule_markdown(@video))
  end

  def new

  end


  private

  def video_params
    params.require(:video).permit(:link, :title, :cohort_id)
  end

  def render_schedule_markdown(video)
    videos = video.cohort.videos
    html_string = VideoTemplater.generate_template(videos)
    MarkdownConverter.convert(html_string)
  end

end
