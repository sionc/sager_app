require 'spec_helper'

describe PagesController do

  context "user is not signed in," do
    it "it should reject unauthorized access to all actions" do
      get :user_sensors
      response.should redirect_to new_user_session_url
    end
  end

  context "user is signed in," do

    before (:each) do
      # @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.create(:user)
      sign_in @user
      @hub = FactoryGirl.create(:hub, :user => @user)
    end

    describe "GET user_sensors" do
     it "assigns current user's sensors as @user_sensors" do
        sensor = FactoryGirl.create(:sensor, :hub => @hub)
        get :user_sensors, {}
        assigns(:user_sensors).should eq([sensor])
     end
    end

  end

end
