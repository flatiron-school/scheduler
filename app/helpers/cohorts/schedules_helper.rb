module Cohorts
  module SchedulesHelper
    
    def render_room_reservations_partial(schedule)
      j render partial: 'cohorts/schedules/room_reservations', locals: {schedule: schedule}
    end

    def render_deploy_history_partial(schedule, github_wrapper)
      j render partial: 'cohorts/schedules/deploy_history', locals: {schedule: schedule, github_wrapper: github_wrapper}
    end

  end
end
