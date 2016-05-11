require 'rails_helper'

feature "CreateNewCalendarEvent", :type => :feature do
  describe "make a room reservation on google calendar", :js => true do
    xit "reserves a classroom on the google calendar for any schedule activities that have reserve_room = true" do
      VCR.use_cassette("google_calendar_reservations") do 
        sign_in
        schedule = make_schedule_to_edit
        visit "/cohorts/web-1117/schedules/#{schedule.slug}"
        click_link "reserve rooms"
        wait_for_ajax
        new_calendar_event = schedule.calendar_events.first
        
        expect(new_calendar_event.schedule).to eq(schedule)
        expect(new_calendar_event.name).to eq('Blogs')
        expect(new_calendar_event.location).to eq('Classroom - Kay')
        expect(new_calendar_event.reserved_by).to eq('sophie@flatironschool.com')
        expect(new_calendar_event.link).to eq('https://www.google.com/calendar/event?eid=OW9wOHJndHVsZWhndDhraW12b241cHA3YTggZmxhdGlyb25zY2hvb2wuY29tX3ZhcmhpZzQ3ZW1lazJlZ2RqbjJuMnBxbTQwQGc')
      end
    end
  end

  describe "reserve rooms and update page", :js => true do 
    xit "reserves a room and updates the page with the reservation confirmation, without refreshing" do 
      VCR.use_cassette("google_calendar_reservations") do 
        schedule = make_schedule_to_edit
        sign_in
        visit "/cohorts/web-1117/schedules/#{schedule.slug}"
        click_link "reserve rooms"
        wait_for_ajax
        expect(page.body).to include("Blogs\nlocation: Classroom - Kay")
        expect(current_path).to eq("/cohorts/web-1117/schedules/#{schedule.slug}")
      end
    end
  end
end
