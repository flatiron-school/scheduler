class SchedulesController < ApplicationController

  before_action :set_cohort_and_schedule, except: [:create, :index, :new]
  before_action :set_cohort, only: [:create, :index, :new]
  before_action :set_github_wrapper, only: [:deploy, :update]

  def index
    @schedules = @cohort.schedules
    render 'cohorts/schedules/index'
  end

  def new
    # FIXME: Models shouldn't know about forms.
    @schedule= Schedule.new_for_form
    render "cohorts/schedules/new"
  end

  def create
    # FIXME: I think all this needs to be pushed into the model and delegated
    # from @cohort. Also models shouldn't know about params but rather just hashes.
    # `@cohort.build_schedule` and `@cohort.create_schedule`
    # That method should call on Schedule and then can trigger these other
    # build methods. I could also imagine passing flags into these methods
    # to determine whether to always build_labs, build_activities, etc.
    @schedule = Schedule.create_from_params(schedule_params, @cohort)
    @schedule.build_labs(validated_labs_params)
    @schedule.build_activities(validated_activity_params)
    @schedule.build_objectives(validated_objectives_params)
    @schedule.get_blogs
    if @schedule.save
      # NOTE: I'd try to get the GitHub interactions into a model by injecting
      # the wrapper should you need data from the controller but I don't think
      # you do. @schedule should know more about pushing to GitHub than the controller.
      set_github_wrapper
      create_schedule_on_github
      redirect_to cohort_schedule_path(@cohort, @schedule)
    else
      render 'cohorts/schedules/new'
    end
  end

  def edit
    render 'cohorts/schedules/edit'
  end

  def show
    render 'cohorts/schedules/show'
  end


  def update
    @schedule.update_from_params(schedule_params)
    if @schedule.save
      update_schedule_on_github
      redirect_to cohort_schedule_path(@schedule.cohort, @schedule)
    else
      render 'cohorts/schedules/edit'
    end
  end


  def deploy
    # NOTE: This seems magic, no idea what it does. Is there a deployments resource
    # you want to expose that can more directly create a deployment of a schedule
    # via REST?
    @schedule.deploy = true
    @schedule.save
    # NOTE: Model should do this.
    deploy_schedule_to_readme
    respond_to do |format|
      format.js {render template: 'cohorts/schedules/deploy.js.erb'}
    end
  end

  def reserve_rooms
    # NOTE: Sounds like there is a RoomReservation resource controller with a new / create.
    #       Discover resources to expose through REST when you have a non RESTful action.
    configure_google_calendar_client
    @calendar.book_events(@schedule)
    respond_to do |format|
      format.js {render template: 'cohorts/schedules/reserve_rooms.js.erb'}
    end

  end

  private
  def schedule_params
    params.require(:schedule).permit(:week, :day, :date, :notes, :deploy, :labs_attributes => [:id, :name], :activities_attributes => [:id, :start_time, :end_time, :description, :reserve_room], :objectives_attributes => [:id, :content])
  end

  # NOTE: Why isn't the model doing all these validations?
  def validated_activity_params
    schedule_params["activities_attributes"].delete_if {|num, activity_hash| activity_hash["start_time"].empty? || activity_hash["description"].empty? || activity_hash["end_time"].empty?}
  end

  def validated_labs_params
    schedule_params["labs_attributes"].delete_if {|num, lab_hash| lab_hash["name"].empty?}
  end

  def validated_objectives_params
    schedule_params["objectives_attributes"].delete_if {|num, obj_hash| obj_hash["content"].empty?}
  end

  def create_schedule_on_github
    @github_wrapper.create_repo_schedules
  end

  def update_schedule_on_github
    @github_wrapper.update_repo_schedules
  end

  def deploy_schedule_to_readme
    @github_wrapper.update_readme
  end

  def render_schedule_template
    # NOTE: Super cool! Is this really needed here though? Sounds like a
    #       ScheduleTemplate service object and unless you need the entire
    #       Controller/View stack can't you just use Tilt to do the ERB rendering?
    #       It doesn't look like you need any Rails stuff in that view.
    #       I'd also think about moving/renaming that view as it's really a template
    #       Not a view rendered by anything else right?
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    view.assign(schedule: @schedule)
    view.render(file: 'cohorts/schedules/github_show.html.erb')
  end

  def set_cohort_and_schedule
    @cohort = Cohort.find_by_name(params[:cohort_slug])
    @schedule = @cohort.schedules.find_by(slug: params[:slug])
  end

  def set_cohort
    @cohort = Cohort.find_by_name(params[:cohort_slug])
  end

  def configure_google_calendar_client
    @calendar = GoogleCalWrapper.new(current_user)
  end

  def set_github_wrapper
    page = render_schedule_template
    @github_wrapper = GithubWrapper.new(@schedule.cohort, @schedule, page)
  end

end
