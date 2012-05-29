require 'spec_helper'

describe "sensor_readings/index" do
  before(:each) do
    assign(:sensor_readings, [
      stub_model(SensorReading,
        :watthours => 1,
        :sensor_id => 2
      ),
      stub_model(SensorReading,
        :watthours => 1,
        :sensor_id => 2
      )
    ])
  end

  it "renders a list of sensor_readings" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
