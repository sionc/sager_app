require 'spec_helper'

describe "hubs/edit" do
  before(:each) do
    @hub = assign(:hub, stub_model(Hub,
      :mac_address => "MyString",
      :user_id => 1
    ))
  end

  it "renders the edit hub form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => hubs_path(@hub), :method => "post" do
      assert_select "input#hub_mac_address", :name => "hub[mac_address]"
      assert_select "input#hub_user_id", :name => "hub[user_id]"
    end
  end
end
