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
  end

  def new

  end


  private

  def video_params
    params.require(:video).permit(:link, :title, :cohort_id)
  end

end
