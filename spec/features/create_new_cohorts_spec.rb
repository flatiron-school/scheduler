require 'rails_helper'

feature "CreateNewCohorts", :type => :feature do
  describe "create new cohort" do
    it "lets you create a new cohort" do
      visit '/'
      fill_in "Name", with: "web-1115"
      click_button 'Create Cohort'
      expect(current_path).to eq('/cohorts/web-1115')
      expect(page.body).to include('web-1115')
    end
  end
end
