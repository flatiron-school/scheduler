module Cohorts
  module SchedulesHelper
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
