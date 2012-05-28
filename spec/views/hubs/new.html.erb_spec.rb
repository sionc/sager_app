require 'spec_helper'

describe "hubs/new" do
  before(:each) do
    assign(:hub, stub_model(Hub,
      :mac_address => "MyString",
      :user_id => 1
    ).as_new_record)
  end

  it "renders new hub form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => hubs_path, :method => "post" do
      assert_select "input#hub_mac_address", :name => "hub[mac_address]"
      assert_select "input#hub_user_id", :name => "hub[user_id]"
    end
  end
end
