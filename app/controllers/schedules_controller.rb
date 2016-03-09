class SchedulesController < ApplicationController
  def new
    @cohort = Cohort.find_by_name(params[:cohort_slug])
    @schedule = Schedule.new
    
    3.times do 
      @schedule.labs << Lab.new
    end

    10.times do
      @schedule.activities << Activity.new
    end

    render "cohorts/schedules/new"
  end

  def create
    schedule = Schedule.new(date: schedule_params["date"], notes: schedule_params["notes"])
    schedule_params["labs_attributes"].each do |num, lab_hash|
      lab = Lab.find_by(name: lab_hash["name"]) || Lab.new(name: lab_hash["name"])
      schedule.labs << lab
      lab.schedule = schedule
    end
    binding.pry
    validated_activity_params.each do |num, activity_hash|
      binding.pry
      activity = Activity.new(time: activity_hash["time"], description: activity_hash["description"])
      schedule.activities << activity
      activity.schedule = schedule
    end
    if schedule.save
       cohort = Cohort.find_by_name(params[:cohort_slug])
      redirect_to cohort_schedule_path(cohort, schedule)
    else
      render 'cohorts/schedules/new'
    end
  end

  def show
    @schedule = Schedule.find_by(slug: params[:slug])
    binding.pry
    page = render 'cohorts/schedules/show'
    schedule_template_content = page.split("<h1>").second.prepend("<h1>").split("</body>").first
    markdown_content = ReverseMarkdown.convert(schedule_template_content)
    #then do the GH magic
  end

  private
  def schedule_params
    params.require(:schedule).permit(:date, :notes, :labs_attributes => [:name], :activities_attributes => [:time, :description])  
  end

  def validated_activity_params
    schedule_params["activities_attributes"].delete_if {|num, activity_hash| activity_hash["time"].empty? || activity_hash["description"].empty?}
  end
end
