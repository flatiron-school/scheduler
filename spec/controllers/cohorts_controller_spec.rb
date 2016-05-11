require 'rails_helper'

RSpec.describe CohortsController, :type => :controller do
  describe "creating cohorts" do
    xit "creates cohorts" do
      expect do
        post :create, {cohort: {name: "drake"}}
      end.to change {Cohort.count}.from(0).to(1)
      expect(response).to redirect_to('/cohorts/drake')
    end
  end
end
