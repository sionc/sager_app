require 'spec_helper'

describe "sensors/new" do
  before(:each) do
    assign(:sensor, stub_model(Sensor,
      :name => "MyString",
      :hub_id => 1
    ).as_new_record)
  end

  it "renders new sensor form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => sensors_path, :method => "post" do
      assert_select "input#sensor_name", :name => "sensor[name]"
      assert_select "input#sensor_hub_id", :name => "sensor[hub_id]"
    end
  end
end
