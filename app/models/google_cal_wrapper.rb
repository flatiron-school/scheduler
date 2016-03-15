class GoogleCalWrapper

  RESOURCE_ID_MAP = {
    "flatironschool.com_36383633393236392d333336@resource.calendar.google.com" => "Classroom - Kay", 
    "flatironschool.com_31373632383930392d313938@resource.calendar.google.com" => "Classroom - Hopper",
    "flatironschool.com_31373234393535322d343338@resource.calendar.google.com" => "Classroom - Turing"
  }

  RESOURCE_IDS = [
    {id: "flatironschool.com_36383633393236392d333336@resource.calendar.google.com"},
    {id: "flatironschool.com_31373234393535322d343338@resource.calendar.google.com"},
    {id: "flatironschool.com_31373632383930392d313938@resource.calendar.google.com"}
  ]

  attr_accessor :client, :service

  def initialize(current_user)
    configure_client(current_user)
  end

  def configure_client(current_user)
    @client = Google::APIClient.new
    @client.authorization.access_token = current_user.token
    @client.authorization.refresh_token = current_user.refresh_token
    @client.authorization.client_id = ENV['GOOGLE_CLIENT_ID']
    @client.authorization.client_secret = ENV['GOOGLE_CLIENT_SECRET']
    @client.authorization.refresh!
    @service = @client.discovered_api('calendar', 'v3')
  end

  def best_available_location(date, activity_start_time, activity_end_time)
    check_available_rooms(date, activity_start_time, activity_end_time)
  end

  def check_available_rooms(date, activity_start_time, activity_end_time)
    binding.pry
    start_time = date.strftime("%Y-%m-%dT%H:%M:%S+%H%M")[0..-5] << "1400"
    end_time = (date + 23.hours).strftime("%Y-%m-%dT%H:%M:%S+%H%M")
    
    response = @client.execute(api_method: @service.freebusy.query, 
      body: JSON.dump({timeMin: start_time,
        timeMax: end_time,
        timeZone: "EST",
        items: RESOURCE_IDS}),
      headers: {'Content-Type' => 'application/json'}
    )
    response = JSON.parse(response.body)
    free_room = nil
    response["calendars"].each do |cal_id, data|
      data.each do |busy, times|
        binding.pry
        i = 0
        while i <= times.length
          binding.pry
          if i == 0 
            binding.pry
            if activity_start_time < times[i]["start"]
              binding.pry
              free_room = cal_id
              break
            end
          else
            binding.pry
            if activity_start_time >= times[i]["end"] && activity_end_time <= times[i + 1]["end"]
              binding.pry
              free_room = cal_id
              break
            end
          end
        end
        binding.pry
        if free_room
          break
        end
      end
    end
    binding.pry
  
  end

  def conflict?

  end

  def build_calendar_events(reservation_activities, date)
    binding.pry
    reservation_activities.map do |activity|
      binding.pry
      start_time = format_date(date, activity.start_time)
      end_time = format_date(date, activity.end_time)
      
      # start_num_of_hours = activity.start_time.hour
      # end_num_of_hours = activity.end_time.hour
      # start = 
      # endt =  
      available_location = best_available_location(date, start_time, end_time)
      {summary: activity.description, 
        location: available_location,
        start: {dateTime: start_time},  
        end: {dateTime: end_time},  
        description: activity.description,  
      } 
    end
  end

  def format_date(date, activity_time)
    binding.pry
    # num_of_hours = activity_time.hour
    # num_of_hours = num_of_hours.to_datetime.hour
    # date = date.to_s[0..-4] << "EST"
    date = date + (activity_time.hour.hours)
    date.strftime("%Y-%m-%dT%H:%M:%S+%H%M")
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

