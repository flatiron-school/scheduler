class NewScheduleBuilder

  def self.create_empty_schedule
    Schedule.new.tap do |schedule|
      schedule.date = Date.tomorrow
      
      3.times do
        schedule.objectives << Objective.new
      end

      3.times do
        schedule.labs << Lab.new
      end

      3.times do
        schedule.activities << Activity.new
      end
    end
  end
end
