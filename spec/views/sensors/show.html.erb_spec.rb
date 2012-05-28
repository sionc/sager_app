require 'spec_helper'

describe "sensors/show" do
  before(:each) do
    @sensor = assign(:sensor, stub_model(Sensor,
      :name => "Name",
      :hub_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/1/)
  end
end
