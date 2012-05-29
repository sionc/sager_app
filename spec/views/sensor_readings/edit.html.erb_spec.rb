require 'spec_helper'

describe "sensor_readings/edit" do
  before(:each) do
    @sensor_reading = assign(:sensor_reading, stub_model(SensorReading,
      :watthours => 1,
      :sensor_id => 1
    ))
  end

  it "renders the edit sensor_reading form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => sensor_readings_path(@sensor_reading), :method => "post" do
      assert_select "input#sensor_reading_watthours", :name => "sensor_reading[watthours]"
      assert_select "input#sensor_reading_sensor_id", :name => "sensor_reading[sensor_id]"
    end
  end
end
