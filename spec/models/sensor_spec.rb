require 'spec_helper'

describe Sensor do
  it 'should not have an empty or nil MAC address' do
    sensor = FactoryGirl.build(:sensor, :mac_address => '')
    sensor.should_not be_valid
    sensor.save.should == false
  end

  it 'should not have the same MAC address as another sensor' do
    sensor1 = FactoryGirl.create(:sensor)
    sensor2 = FactoryGirl.build(:sensor, :mac_address => sensor1.mac_address)
    sensor2.should_not be_valid
    sensor2.save.should == false
  end

  it 'should not exist without an associated user' do
    sensor = FactoryGirl.build(:sensor, :user => nil)
    sensor.should_not be_valid
    sensor.save.should == false
  end

  it 'should calculate kwh usage for one hour for a given date and hour' do
    sensor1 = FactoryGirl.create(:sensor)

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
    sensor1.total_hour_kwh_usage_on(time.to_date, time.hour).
      should be_within(1.0e-16).of(kwh_usage)
  end

  it 'should calculate kwh usage for a given date' do
    sensor1 = FactoryGirl.create(:sensor)

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
    sensor1.total_day_kwh_usage_on(time.to_date).
      should be_within(1.0e-16).of(kwh_usage_per_hour * num_hours)
  end

   it 'should calculate kwh usage for the week until the given date' do
    sensor1 = FactoryGirl.create(:sensor)

    time = Time.utc(2012, 1, 10, 11, 58)
    num_days = time.wday + 1
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
    sensor1.total_week_kwh_usage_until(time.to_date).
      should be_within(1.0e-14).of(kwh_usage_per_day * num_days)
   end

  it 'should calculate kwh usage for the month until the given date' do
    sensor1 = FactoryGirl.create(:sensor)

    time = Time.utc(2012, 1, 2, 11, 58)
    num_days = time.day
    num_hours = 2
    num_readings = 2
    t = time

    (1..num_days).each do |i|
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
    sensor1.total_month_kwh_usage_until(time.to_date).
      should be_within(1.0e-14).of(kwh_usage_per_day * num_days)
   end
end
