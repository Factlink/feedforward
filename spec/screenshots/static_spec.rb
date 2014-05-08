require 'acceptance_helper'

describe "Static pages:", type: :feature do
  include ScreenshotTest
  include FeedHelper

  describe "Homepage" do
    it do
      create_default_activities_for create(:user)

      visit "/"

      assume_unchanged_screenshot "static_homepage"
    end
  end
end
