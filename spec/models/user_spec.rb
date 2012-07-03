require 'spec_helper'
require 'cancan/matchers'

describe User do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @sensor = FactoryGirl.create(:sensor, :user => @user)
    @sensor_reading = FactoryGirl.create(:sensor_reading, :sensor => @sensor)
    @ability = Ability.new(@user)
  end

  it 'should be able to manage its sensor' do
    @ability.should be_able_to(:manage, @sensor)
  end

  it 'should be able to create a sensor' do
    @ability.should be_able_to(:create, Sensor.new)
  end

  it 'should not be able to manage others\' sensors' do
    sensor = FactoryGirl.build(:sensor)
    @ability.should_not be_able_to(:manage, sensor)
  end

  it 'should be able to read sensor readings' do
    @ability.should be_able_to(:read, @sensor_reading)
  end

  it 'should not be able to manage others\' readings' do
    sensor_reading = FactoryGirl.build(:sensor_reading)
    @ability.should_not be_able_to(:read, sensor_reading)
  end
end
