class GoogleCalWrapper

  RESOURCE_ID_MAP = {
    "flatironschool.com_36383633393236392d333336@resource.calendar.google.com" => "Classroom - Kay", 
    "flatironschool.com_31373632383930392d313938@resource.calendar.google.com" => "Classroom - Hopper",
    "flatironschool.com_31373234393535322d343338@resource.calendar.google.com" => "Classroom - Turing"
  }

  RESOURCE_IDS = [
    {
      id: "flatironschool.com_36383633393236392d333336@resource.calendar.google.com",
      id: "flatironschool.com_31373234393535322d343338@resource.calendar.google.com",
      id: "flatironschool.com_31373632383930392d313938@resource.calendar.google.com"
    }
  ]

  attr_accessor :client, :service

  def initialize
    configure_google_calendar_client
  end

  def configure_client
    @client = Google::APIClient.new
    @client.authorization.access_token = current_user.token
    @client.authorization.refresh_token = current_user.refresh_token
    @client.authorization.client_id = ENV['GOOGLE_CLIENT_ID']
    @client.authorization.client_secret = ENV['GOOGLE_CLIENT_SECRET']
    @client.authorization.refresh!
    @service = @client.discovered_api('calendar', 'v3')
  end

  def best_available_location(start_time, end_time)
    check_available_rooms
  end

  def check_available_rooms(start_time, end_time)
    response = @client.execute(api_method: @service.freebusy.query,
      parameters: {
        timeMin: start_time,
        timeMax: end_time,
        timeZone: "EST",
        items: RESOURCE_IDS
      })
    response = JSON.parse(response)
    #response[:calendars]
    #iterate over response[:calendars] and compare the blocked activities for each room
    # to the start and end time of the activity we are trying to book, as passed in to this method
    # use the #conflict? and/or other helper methods
    # ultimately, this method should return the name, i.e. 'Classroom - Kay', if the best available
    # room. Use Resource Map constant to get room name from resource ID. Best to worst: Kay, Turing, Hopper.
  end

  def conflict?

  end

  def build_calendar_events(reservation_activities)
    reservation_activities.map do |activity|
      start_num_of_hours = activity.start_time.hour
      end_num_of_hours = activity.end_time.hour
      start = self.date + (start_num_of_hours + 4).hours
      endt =  self.date + (end_num_of_hours + 4).hours
      available_location = best_available_location(start, endt)
      {summary: activity.description, 
        location: available_location,
        start: {dateTime: start.to_datetime},  
        end: {dateTime: endt.to_datetime},  
        description: activity.description,  
      } 
    end
  end




#  {
#   "kind": "calendar#freeBusy",
#  "timeMin": "2016-03-15T00:00:00.000Z",
#  "timeMax": "2016-03-15T23:00:00.000Z",
#  "calendars": {
#   "flatironschool.com_31373234393535322d343338@resource.calendar.google.com": {
#    "busy": [
#     {
#      "start": "2016-03-14T19:00:00-05:00",
#      "end": "2016-03-14T20:00:00-05:00"
#     },
#     {
#      "start": "2016-03-15T15:30:00-05:00",
#      "end": "2016-03-15T16:00:00-05:00"
#     },
#     {
#      "start": "2016-03-15T16:45:00-05:00",
#      "end": "2016-03-15T17:00:00-05:00"
#     },
#     {
#      "start": "2016-03-15T17:15:00-05:00",
#      "end": "2016-03-15T18:00:00-05:00"
#     }
#    ]
#   }
#  }
# }


end

