require 'spec_helper'

describe Hub do

  # disclaimer: I couldn't get the it/specify syntax to work, should be
  # able to refactor that later once I have more experience with rspec

  it "should not be valid without a mac address" do
    hub = FactoryGirl.build(:hub, :mac_address => "")
    hub.should_not be_valid
    hub.save.should == false
  end

  it "should not be valid without a user_id" do
    hub = FactoryGirl.build(:hub, :user_id => nil)
    hub.should_not be_valid
    hub.save.should == false
  end

  it "should be valid with all of the parameters set" do
    hub = FactoryGirl.build(:hub)
    hub.should be_valid
    hub.save.should == true
  end

  it "should not be possible to insert the same mac address twice" do
    hub = FactoryGirl.create(:hub)
    hub2 = FactoryGirl.build(:hub, :mac_address => hub.mac_address)
    hub2.save.should == false
  end

  describe "associations" do
    it "should not belong to more than one user" do
      user = FactoryGirl.create(:user)
      hub = FactoryGirl.create(:hub, :user => user)
      hub2 = FactoryGirl.build(:hub, :mac_address => "different address", :user => user)
      hub2.should_not be_valid
      hub2.save.should == false
    end
  end

  # context "when mac_address empty" do
  #   @hub.mac_address = ""
  #   it { should_not be_valid }
  #   specify { @hub.save.should == false }
  # end

  # context "when user_id not set" do
  #   @hub.user_id = nil
  #   it { should_not be_valid }
  #   specify { @hub.save.should == false }
  # end
end
