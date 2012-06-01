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

  it 'should calculate kwh usage for one hour for a given date and hour' do
    hub1 = FactoryGirl.create(:hub)
    sensor1 = FactoryGirl.create(:sensor, :hub => hub1)

    time = Time.utc(2012, 1, 1, 11, 58)
    num_readings = 2
    t = time
    (1..num_readings).each do |i|
      reading = FactoryGirl.create(:sensor_reading, :sensor => sensor1)
      reading.created_at = t - i.minutes
      reading.save!
    end

    cumulative_usage = (1337 * num_readings).to_f
    average_usage = cumulative_usage/60
    kwh_usage = average_usage/1000
    sensor1.hourly_kwh_usage_on(time.to_date, time.hour).should == kwh_usage
  end

  it 'should calculate kwh usage for a given date' do
    hub1 = FactoryGirl.create(:hub)
    sensor1 = FactoryGirl.create(:sensor, :hub => hub1)

    time = Time.utc(2012, 1, 1, 11, 58)
    num_hours = 2
    num_readings = 2
    t = time
    (0..num_hours-1).each do |i|
      (0..num_readings-1).each do |j|
        reading = FactoryGirl.create(:sensor_reading, :sensor => sensor1)
        reading.created_at = t - j.minutes
        reading.save!
      end
      t = t - 1.hour
    end

    cumulative_usage_per_hour = (1337 * num_readings).to_f
    average_usage_per_hour = cumulative_usage_per_hour/60
    kwh_usage_per_hour = average_usage_per_hour/1000
    sensor1.daily_kwh_usage_on(time.to_date).should == (kwh_usage_per_hour * num_hours)
  end

   it 'should calculate kwh usage for the week upto the given date' do
    hub1 = FactoryGirl.create(:hub)
    sensor1 = FactoryGirl.create(:sensor, :hub => hub1)

    time = Time.utc(2012, 1, 10, 11, 58)
    num_days = 7
    num_hours = 2
    num_readings = 2
    t = time

    (0..num_days-1).each do |i|
      t = time - i.days
      (0..num_hours-1).each do |j|
        (0..num_readings-1).each do |k|
          reading = FactoryGirl.create(:sensor_reading, :sensor => sensor1)
          reading.created_at = t - k.minutes
          reading.save!
        end
        t = t - 1.hour
      end
    end

    cumulative_usage_per_hour = (1337 * num_readings).to_f
    average_usage_per_hour = cumulative_usage_per_hour/60
    kwh_usage_per_hour = average_usage_per_hour/1000
    kwh_usage_per_day =  kwh_usage_per_hour * num_hours
    sensor1.weekly_kwh_usage_until(time.to_date).should == (kwh_usage_per_day * num_days)
   end
end
