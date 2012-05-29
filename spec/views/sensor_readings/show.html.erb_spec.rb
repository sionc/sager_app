require 'spec_helper'

describe "sensor_readings/show" do
  before(:each) do
    @sensor_reading = assign(:sensor_reading, stub_model(SensorReading,
      :watthours => 1,
      :sensor_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
