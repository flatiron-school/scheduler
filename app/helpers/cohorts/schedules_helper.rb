module Cohorts
  module SchedulesHelper
    # NOTE: These feels like boolean methods on schedule
    def blogs?(schedule)
      !schedule.blog_assignments.empty?
    end

    def notes?(schedule)
      !schedule.notes.empty?
    end

    def objectives?(schedule)
      !schedule.objectives.empty?
    end

    def labs?(schedule)
      !schedule.labs.empty?
    end
  end
end
