require 'spec_helper'

describe "hubs/index" do
  before(:each) do
    assign(:hubs, [
      stub_model(Hub,
        :mac_address => "Mac Address",
        :user_id => 1
      ),
      stub_model(Hub,
        :mac_address => "Mac Address",
        :user_id => 1
      )
    ])
  end

  it "renders a list of hubs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Mac Address".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
