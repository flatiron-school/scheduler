class RoomReservationsController < ApplicationController

  before_action :set_schedule

  def create
   GoogleCalWrapper.new(current_user).book_events(@schedule)
    respond_to do |format|
      format.js {render template: 'cohorts/schedules/reserve_rooms.js.erb'}
    end
  end

  def set_schedule
    @schedule = Schedule.find(params[:schedule_id])
  end

end