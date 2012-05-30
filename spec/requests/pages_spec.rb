require 'spec_helper'

describe "Pages" do

   describe "About page" do

    it "should have the content 'About Us'" do
      visit '/pages/about'
      page.should have_content('About Us')
    end
  end
end
