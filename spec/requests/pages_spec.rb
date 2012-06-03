require 'spec_helper'

describe "Pages" do

  describe "GET /pages/about" do
    it "should render about page" do
      get "/pages/about"
      response.status.should be(200)
    end
  end

end
