require 'spec_helper'

describe SensorReading do
  it "should be associated with a sensor" do
    reading = FactoryGirl.build(:sensor_reading, :sensor => nil)
    reading.should_not be_valid
    reading.save.should == false
  end

  it "should succeed in the correct case" do
    reading = FactoryGirl.build(:sensor_reading)
    reading.should be_valid
    reading.save.should == true
  end
end
