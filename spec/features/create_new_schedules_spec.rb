require 'rails_helper'

feature "CreateNewSchedules", :type => :feature do
  describe "create new schedule" do
    it "lets you create a new schedule with its associated labs and activities" do
      VCR.use_cassette("create_schedule") do 
        make_new_schedule
        expect(current_path).to eq('/cohorts/web-1117/schedules/feb-01-2017')
        expect(page.body).to include('Week 1')
        expect(page.body).to include('Day 44')
        expect(page.body).to include('test notes')
        expect(page.body).to include('lab-1')
        expect(page.body).to include('barking-dog')
        expect(page.body).to include('lab-3')
        expect(page.body).to include('09:00')
        expect(page.body).to include('TODO')
        expect(Schedule.last.sha).to eq('c251a71e96e5983a688557b788571ba47cb819d6')
      end
    end
  end

  describe "edit an existing schedule" do 
    it "edits a schedule" do 
      VCR.use_cassette("edit_schedule") do 
        sign_in
        schedule = make_schedule_to_edit
        visit "/cohorts/web-1117/schedules/#{schedule.slug}/edit"
        fill_in_edit_schedule_form
        expect(current_path).to eq('/cohorts/web-1117/schedules/jan-02-2017')
        expect(page.body).to include('Week 1')
        expect(page.body).to include('Day 44')
        expect(page.body).to include('lab-100')
        expect(page.body).to include('10:00')
        expect(page.body).to include('Lecture')
      end
    end
  end
end
