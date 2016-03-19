require 'rails_helper'

RSpec.describe User, :type => :model do
  describe "#name" do 
    it 'has a name' do 
      user = FactoryGirl.build(:user)
      expect(user.name).to eq("sophie")
    end
  end

  describe "associations" do 
    it "has many cohorts" do 
      user = FactoryGirl.build(:user)
      cohort = FactoryGirl.build(:cohort)
      user.cohorts << cohort
      user.save

      expect(user.cohorts).to include(cohort)
    end

    it "has a cohort that is its active cohort" do 
      user = User.create(email: "sophie@email.com", password: "password", password_confirmation: "password")
      cohort = FactoryGirl.build(:cohort)
      UserCohort.create(user: user, cohort: cohort)
      expect(user.active_cohort).to eq(cohort)
    end
  end
end
