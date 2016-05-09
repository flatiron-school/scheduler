require 'capybara/rspec'
require 'omniauth'
require 'rails_helper'
require_relative './support/vcr_setup.rb'
OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
  :provider => 'google_oauth2',
  :uid => '123545',
  :credentials => 
    {:token => ENV['TEST_GOOGLE_ACCESS_TOKEN'], 
    :refresh_token => ENV['TEST_GOOGLE_REFRESH_TOKEN']},
  :info => {email: "sophie@flatironschool.com"}
})


# require 'webmock/rspec'
# WebMock.enable_net_connect!(allow_localhost: true)  

# WebMock.disable_net_connect!(allow_localhost: true) 

module WaitForAjax
  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end 

RSpec.configure do |config|
 
  config.expect_with :rspec do |expectations|
   
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  
  config.mock_with :rspec do |mocks|
   
    mocks.verify_partial_doubles = true
  end

  Capybara.javascript_driver = :webkit


  config.include WaitForAjax, type: :feature
  require 'factory_girl'

  config.use_transactional_fixtures = false
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    DatabaseCleaner.strategy = :truncation

  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end
end

def sign_in
  visit '/'
  click_link "signin"
end

def fill_in_schedule_form
  fill_in "schedule[week]", with: "1"
  fill_in "schedule[day]", with: "44"
  fill_in "schedule[date]", with: "01/02/2017"
  fill_in "schedule[notes]", with: "test notes"
  fill_in "schedule[labs_attributes][0][name]", with: "lab-1"
  fill_in "schedule[labs_attributes][1][name]", with: "barking-dog"
  fill_in "schedule[labs_attributes][2][name]", with: "lab-3"
  fill_in "schedule[activities_attributes][0][start_time]", with: "9:00AM"
  fill_in "schedule[activities_attributes][0][end_time]", with: "9:30AM"
  fill_in "schedule[activities_attributes][0][description]", with: "TODO"
  click_button 'Create Schedule'
end

def fill_in_edit_schedule_form
  fill_in "schedule[labs_attributes][0][name]", with: "lab-100"
  fill_in "schedule[activities_attributes][0][start_time]", with: "10:00AM"
  fill_in "schedule[activities_attributes][0][end_time]", with: "11:00AM"
  fill_in "schedule[activities_attributes][0][description]", with: "Lecture"
  click_button "Update Schedule"
end

def make_new_schedule
  cohort = Cohort.create(name: "web-1117")
  cohort.save
  sign_in
  UserCohort.create(user: User.find_by(email: "sophie@flatironschool.com"), cohort: cohort, active: true)
  visit "/cohorts/#{cohort.name}/schedules/new"
  fill_in_schedule_form
end

def make_new_cohort
  sign_in
  cohort = FactoryGirl.build(:cohort)
  cohort.save
  UserCohort.create(user: User.find_by(email: "sophie@flatironschool.com"), cohort: cohort, active: true)
  cohort
end


def make_schedule_to_edit
  cohort = Cohort.create(name: "web-1117")
  cohort.save
  UserCohort.create(user: User.find_by(email: "sophie@flatironschool.com"), cohort: cohort, active: true)
  schedule = Schedule.new("date"=>"2017-01-02 00:00:00.000000000 -0500", "notes"=>"Here are some notes", "week"=>"1", "day"=>"44", "cohort"=>cohort, "sha"=>"c251a71e96e5983a688557b788571ba47cb819d6")
  lab = Lab.new(name: "lab-79")
  schedule.labs << lab
  lab.save
  activity = Activity.new(start_time: "9:30AM", end_time: "10:00AM", description: "Blogs", reserve_room: true)
  schedule.activities << activity
  schedule.save
  schedule
end





