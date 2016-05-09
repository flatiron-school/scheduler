require 'rails_helper'

feature "AddVideoLinkToCohort", :type => :feature do
  describe "video modal toggle" do
    it "does not show video link if the cohort is not the current users active cohort" do
      VCR.use_cassette("add_video_link") do
        make_new_cohort_without_active_user
        visit "/cohorts/web-1125"
        expect(current_path).to eq("/cohorts/web-1125")
        expect(page).not_to have_link("video_modal")
      end
    end
  end

  describe "show video modal" do
    it "shows the link to video modal when the user is on their active cohort show page" do
      VCR.use_cassette("add_video_link") do
        sign_in_with_active_cohort
        visit "/cohorts/web-1125"
        expect(current_path).to eq("/cohorts/web-1125")
        expect(page.body).to include("video_modal")
      end
    end
  end

  describe "add video link", :js => true do
    it "adds a valid video link to a cohorts show page" do
      VCR.use_cassette("add_video_link") do
        sign_in_with_active_cohort
        visit "/cohorts/web-1125"
        click_link "video_modal"
        fill_in "video_title", with: "Test Title"
        fill_in "video_link", with: "https://www.youtube.com/"
        click_button "Add Link"
        wait_for_ajax
        expect(current_path).to eq('/cohorts/web-1125')
        expect(page.body).to include("Test Title")
      end
    end
  end
end
