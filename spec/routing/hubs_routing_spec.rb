require "spec_helper"

describe HubsController do
  describe "routing" do

    it "routes to #index" do
      get("/hubs").should route_to("hubs#index")
    end

    it "routes to #new" do
      get("/hubs/new").should route_to("hubs#new")
    end

    it "routes to #show" do
      get("/hubs/1").should route_to("hubs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/hubs/1/edit").should route_to("hubs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/hubs").should route_to("hubs#create")
    end

    it "routes to #update" do
      put("/hubs/1").should route_to("hubs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/hubs/1").should route_to("hubs#destroy", :id => "1")
    end

  end
end
