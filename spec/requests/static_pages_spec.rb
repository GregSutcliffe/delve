require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the content 'Delve'" do
      visit '/static_pages/home'
      expect(page).to have_content('Welcome to Delve')
    end
  end

  describe "Help page" do

    it "should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('How to get help')
    end
  end

end
