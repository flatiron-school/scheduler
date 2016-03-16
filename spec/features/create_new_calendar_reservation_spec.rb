require 'rails_helper'

feature "CreateNewCalendarEvent", :type => :feature do
  describe "make a room reservation on google calendar" do
    it "reserves a classroom on the google calendar for any schedule activities that have reserve_room = true" do
      schedule = make_schedule_to_edit
      sign_in
      visit "/cohorts/web-1117/schedules/#{schedule.slug}"
      click_button "reserve rooms"
      expect(current_path).to eq('/cohorts/web-1115')
      expect(page.body).to include('web-1115')
    end
  end

  describe "edit an exist cohort" do 
    it "edits a cohort" do 
      cohort = FactoryGirl.build(:cohort)
      cohort.save

      sign_in
      visit "/cohorts/#{cohort.name}"
      click_link "edit"
      fill_in "Name", with: "web-1120"
      click_button "Update Cohort"
      expect(current_path).to eq('/cohorts/web-1120')
      expect(page.body).to include('web-1120')
    end
  end
end
