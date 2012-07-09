require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe SchedulesController do
  context "user is not signed in" do
      it "should reject unauthorized access to all actions" do
        get :index
        response.should redirect_to new_user_session_url
        get :show
        response.should redirect_to new_user_session_url
        get :new
        response.should redirect_to new_user_session_url
        get :edit
        response.should redirect_to new_user_session_url
        post :create
        response.should redirect_to new_user_session_url
        put :update
        response.should redirect_to new_user_session_url
        delete :destroy
        response.should redirect_to new_user_session_url
      end
    end

   context "user is signed in" do

    before (:each) do
      # @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.create(:user)
      sign_in @user
      @sensor = FactoryGirl.create(:sensor)
    end

  # This should return the minimal set of attributes required to create a valid
  # Schedule. As you add validations to Schedule, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {:sensor_id => @sensor.id}.merge(FactoryGirl.attributes_for(:schedule))
  end

  describe "GET index" do
    it "assigns all schedules as @schedules" do
      schedule = FactoryGirl.create(:schedule)
      get :index, {}
      assigns(:schedules).should eq([schedule])
    end

    it "assigns all the specified sensor's schedules as @schedules" do
      sensor1 = FactoryGirl.create(:sensor)
      sensor2 = FactoryGirl.create(:sensor)
      schedule1 = FactoryGirl.create(:schedule, :sensor_id => sensor1.id)
      schedule2 = FactoryGirl.create(:schedule, :sensor_id => sensor2.id)
      get :index, {:sensor_id => sensor2.id}
      assigns(:schedules).should eq([schedule2])
    end
  end

  describe "GET show" do
    it "assigns the requested schedule as @schedule" do
      schedule = FactoryGirl.create(:schedule)
      get :show, {:id => schedule.to_param}
      assigns(:schedule).should eq(schedule)
    end
  end

  describe "GET new" do
    it "assigns a new schedule as @schedule" do
      get :new, {}
      assigns(:schedule).should be_a_new(Schedule)
    end
  end

  describe "GET edit" do
    it "assigns the requested schedule as @schedule" do
      schedule = FactoryGirl.create(:schedule)
      get :edit, {:id => schedule.to_param}
      assigns(:schedule).should eq(schedule)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Schedule" do
        expect {
          post :create, {:schedule => valid_attributes}
        }.to change(Schedule, :count).by(1)
      end

      it "assigns a newly created schedule as @schedule" do
        post :create, {:schedule => valid_attributes}
        assigns(:schedule).should be_a(Schedule)
        assigns(:schedule).should be_persisted
      end

      it "redirects to the created schedule" do
        post :create, {:schedule => valid_attributes}
        response.should redirect_to(Schedule.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved schedule as @schedule" do
        # Trigger the behavior that occurs when invalid params are submitted
        Schedule.any_instance.stub(:save).and_return(false)
        post :create, {:schedule => {}}
        assigns(:schedule).should be_a_new(Schedule)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Schedule.any_instance.stub(:save).and_return(false)
        post :create, {:schedule => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested schedule" do
        schedule = FactoryGirl.create(:schedule)
        # Assuming there are no other schedules in the database, this
        # specifies that the Schedule created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Schedule.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => schedule.to_param, :schedule => {'these' => 'params'}}
      end

      it "assigns the requested schedule as @schedule" do
        schedule = FactoryGirl.create(:schedule)
        put :update, {:id => schedule.to_param, :schedule => valid_attributes}
        assigns(:schedule).should eq(schedule)
      end

      it "redirects to the schedule" do
        schedule = FactoryGirl.create(:schedule)
        put :update, {:id => schedule.to_param, :schedule => valid_attributes}
        response.should redirect_to(schedule)
      end
    end

    describe "with invalid params" do
      it "assigns the schedule as @schedule" do
        schedule = FactoryGirl.create(:schedule)
        # Trigger the behavior that occurs when invalid params are submitted
        Schedule.any_instance.stub(:save).and_return(false)
        put :update, {:id => schedule.to_param, :schedule => {}}
        assigns(:schedule).should eq(schedule)
      end

      it "re-renders the 'edit' template" do
        schedule = FactoryGirl.create(:schedule)
        # Trigger the behavior that occurs when invalid params are submitted
        Schedule.any_instance.stub(:save).and_return(false)
        put :update, {:id => schedule.to_param, :schedule => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested schedule" do
      schedule = FactoryGirl.create(:schedule)
      expect {
        delete :destroy, {:id => schedule.to_param}
      }.to change(Schedule, :count).by(-1)
    end

    it "redirects to the schedules list" do
      schedule = FactoryGirl.create(:schedule)
      delete :destroy, {:id => schedule.to_param}
      response.should redirect_to(schedules_url)
    end
  end
end
end
