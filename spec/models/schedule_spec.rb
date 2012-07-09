require 'spec_helper'

describe Schedule do
   it 'should have an associated sensor' do
    sensor = FactoryGirl.build(:schedule, :sensor => nil)
    sensor.should_not be_valid
    sensor.save.should == false
   end

  it 'should have a start time' do
    sensor = FactoryGirl.build(:schedule, :start_time => nil)
    sensor.should_not be_valid
    sensor.save.should == false
  end

  it 'should have a end time' do
    sensor = FactoryGirl.build(:schedule, :end_time => nil)
    sensor.should_not be_valid
    sensor.save.should == false
  end
end
