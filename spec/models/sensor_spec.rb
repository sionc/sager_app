require 'spec_helper'

describe Sensor do
  it 'should not have an empty or nil name' do
    sensor = FactoryGirl.build(:sensor, :name => '')
    sensor.should_not be_valid
    sensor.save.should == false
  end

  it 'should not have a duplicate name for the same hub' do
    sensor = FactoryGirl.create(:sensor)
    sensor2 = FactoryGirl.build(:sensor, :name => sensor.name, :hub => sensor.hub)
    sensor2.should_not be_valid
    sensor2.save.should == false
  end

  it 'should be able to have duplicate names for different hubs' do
    sensor = FactoryGirl.create(:sensor)
    sensor2 = FactoryGirl.build(:sensor, :name => sensor.name)
    sensor2.should be_valid
    sensor2.save.should == true
  end

  it 'should not exist without an associated hub' do
    sensor = FactoryGirl.build(:sensor, :hub => nil)
    sensor.should_not be_valid
    sensor.save.should == false
  end

  it 'should be able to have same local id across hubs' do
    hub1 = FactoryGirl.create(:hub)
    hub2 = FactoryGirl.create(:hub)
    sensor1 = FactoryGirl.create(:sensor, :hub => hub1)
    sensor2 = FactoryGirl.build(:sensor, :local_id => sensor1.local_id, :hub => hub2)
    sensor2.should be_valid
    sensor2.save.should == true
  end

  it 'should not have same local id for one hub' do
    hub1 = FactoryGirl.create(:hub)
    sensor1 = FactoryGirl.create(:sensor, :hub => hub1)
    sensor2 = FactoryGirl.build(:sensor, :local_id => sensor1.local_id, :hub => hub1)
    sensor2.should_not be_valid
    sensor2.save.should == false
  end
end
