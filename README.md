# Flatiron Scheduler

Rails app that streamlines and automates the scheduling process for instructors at the Flatiron School.

# Description

Instructors can log in with their Flatiron gmail addresses, add their class' cohort or select a cohort to be their "active" cohort. For you active cohort, you can edit, upload the CSV student roster (download-able from the Learn organization's page for your cohort) and make and edit daily schedules. 

Daily schedule is automatically posted to your active cohort's GitHub repository, from which Learn will pull it as the daily schedule on learn.co. Any schedule activities for which you check "reserve room" will be automatically booked in any available classrooms. 

This app integrates with the [Flatiron Blogger app](https://github.com/flatiron-labs/flatiron-blog-app). It hits the blogger API when a new schedule is created to display that blog posts due that day. 

# Contributing

## Getting Started

This app requires Ruby 2.3.0 and Rails 5. If you don't have those installed on your machine:

* `rvm install 2.3.0`

Note that the Gemfile specifies the Ruby version as well as the Rails version:

```ruby
# Gemfile

ruby '2.3.0'
gem 'rails', '>= 5.0.0.beta3', '< 5.1'
```

Once you have Ruby 2.3.0 installed,

* `git clone git@github.com:flatiron-school/scheduler.git`
* `cd scheduler`
* `bundle install`
* `figaro install` (creates `config/application.yml` and adds it to .gitignore for hiding sensitive information)
* Get credentials for Github and Google from Sophie DeBenedetto (sophie@flatironschool.com), and add these credentials to `config/application.yml`:

```ruby
OCTO_TOKEN: <credential goes here>
GITHUB_ID: <credential goes here>
GITHUB_SECRET: <credential goes here>
GOOGLE_CLIENT_ID: <credential goes here>
GOOGLE_CLIENT_SECRET: <credential goes here>

TEST_GOOGLE_ACCESS_TOKEN: <credential goes here>
TEST_GOOGLE_REFRESH_TOKEN: <credential goes here>
```
* Run `rspec` to get familiar with the test suite. Tests use [VCR](https://github.com/vcr/vcr) to stub web requests. 
* **Note:** There is no seed data provided with this app. Instead:
    * run `rails s`
    * visit the `/cohorts/new` page
    * Give the cohort a name of `web-1115`
    * Upload the student CSV roster found [here](https://www.dropbox.com/s/wmi5vyai7w1x3ln/web-0416.csv?dl=0).
    * The app will automatically pull this cohort's calendar ID from Google Calendar. The Flatiron Blogger App is set up to provide endpoints for a dummy schedule for this cohort, with a start date of March, 2017 and an end date of June, 2017. 

## Tips

* Most of the magic happens in the Schedules Controller. That's where you'll find the actions for deploying a schedule to GitHub and reserving classrooms on Google Calendar. 
* Check out the GitHub Wrapper class and the Google Calendar Wrapper class for the code that interfaces with those APIs. 

## Road Map

A few areas that need work:

* Posting a schedule to GitHub and reserving classrooms on Goole Calendar should be extracted and run in background jobs, using something like Sidekiq.
* Right now, anyone with an `@flatironschool.com` email address can log in. That means students can mess with the schedule. Oh no! We all know how tricky those students can be. You can implement a feature that only allows registered instructors to log in. 
* When a schedule's activities are updated, the google calendar is not updated. If a schedule activity that has `reserve_room=true` updates its start/end time, delete original room reservation first, then make a new one. 
* More tests!  
