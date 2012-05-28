require 'spec_helper'

describe "hubs/show" do
  before(:each) do
    @hub = assign(:hub, stub_model(Hub,
      :mac_address => "Mac Address",
      :user_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Mac Address/)
    rendered.should match(/1/)
  end
end
