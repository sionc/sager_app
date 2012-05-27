require 'spec_helper'

describe "StaticPages" do

  describe "Home page" do

    it "should have the content 'Home'" do
      visit '/static_pages/home'
      page.should have_content('Home')
    end
  end

  describe "Help page" do

    it "should have the content 'Help'" do
      visit '/static_pages/help'
      page.should have_content('Help')
    end
  end

   describe "About page" do

    it "should have the content 'About Us'" do
      visit '/static_pages/about'
      page.should have_content('About Us')
    end
  end
end
