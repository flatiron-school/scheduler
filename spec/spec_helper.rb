require 'capybara/rspec'
require 'omniauth'
require 'ostruct'
require_relative './support/vcr_setup.rb'
OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:github] = OpenStruct.new(:uid => '1337',
    :provider => 'github',
    :info => OpenStruct.new(email: 'sophie@email.com'))

require 'webmock/rspec'  
WebMock.disable_net_connect!(allow_localhost: true)  

RSpec.configure do |config|
 
  config.expect_with :rspec do |expectations|
   
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  
  config.mock_with :rspec do |mocks|
   
    mocks.verify_partial_doubles = true
  end


  require 'factory_girl'
end

def sign_in
  visit '/'
  click_link "signin"
end

def fill_in_schedule_form
  fill_in "Week", with: "1"
  fill_in "schedule[day]", with: "40"
  fill_in "schedule[date]", with: "01/02/2017"
  fill_in "schedule[notes]", with: "test notes"
  fill_in "schedule[labs_attributes][0][name]", with: "lab-1"
  fill_in "schedule[labs_attributes][1][name]", with: "barking-dog"
  fill_in "schedule[labs_attributes][2][name]", with: "lab-3"
  fill_in "schedule[activities_attributes][0][time]", with: "9:00AM"
  fill_in "schedule[activities_attributes][0][description]", with: "TODO"
  click_button 'Create Schedule'
end

def fill_in_edit_schedule_form
  fill_in "schedule[labs_attributes][0][name]", with: "lab-100"
  fill_in "schedule[activities_attributes][0][time]", with: "10:00AM"
  fill_in "schedule[activities_attributes][0][description]", with: "Lecture"
  click_button "Update Schedule"
end

def make_new_schedule
  cohort = Cohort.create(name: "web-1117")
  cohort.save
  sign_in
  UserCohort.create(user: User.find_by(email: "sophie@email.com"), cohort: cohort, active: true)
  visit "/cohorts/#{cohort.name}/schedules/new"
  fill_in_schedule_form
end


def make_schedule_to_edit
  cohort = Cohort.create(name: "web-1117")
  cohort.save
  schedule = Schedule.new("date"=>"Thu, 01 Feb 2017 00:00:00 UTC +00:00", "notes"=>"Here are some notes", "week"=>"1", "day"=>"40", "cohort"=>cohort, "sha"=>"864fbc93a8eb788bf5dae0c9f2cd3b04cd01b2b2")
  lab = Lab.new(name: "lab-79")
  schedule.labs << lab
  lab.save
  activity = Activity.new(time: "9:00AM", description: "TODO")
  schedule.activities << activity
  schedule.save
  schedule
end





