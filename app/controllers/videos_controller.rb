class VideosController < ApplicationController

  def create
    binding.pry
  end

  def new

  end

  private

  def video_params
    params.require(:video).permit(:link, :cohort_id)
  end

end
