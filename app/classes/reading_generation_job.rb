class ReadingGenerationJob
  # mandatory enqueued job method
  def perform
    self.generate_readings
  end

  def generate_readings
    demo_users = User.where({ :demo => true })

    demo_users.each do |user|
      # hack: for demo purposes, you have to have 4 sensors for generation to
      #   work as intended
      if !user.hub.nil? &&
         !user.hub.sensors.nil? &&
         user.hub.sensors.count == 4

        user.hub.sensors[0].sensor_readings <<
          SensorReading.new(:sensor_id => user.hub.sensors[0].id,
                            :watthours => generate_computer_reading)
        user.hub.sensors[1].sensor_readings <<
          SensorReading.new(:sensor_id => user.hub.sensors[1].id,
                            :watthours => generate_microwave_reading)
        user.hub.sensors[2].sensor_readings <<
          SensorReading.new(:sensor_id => user.hub.sensors[2].id,
                            :watthours => generate_entertainment_reading)
        user.hub.sensors[3].sensor_readings <<
          SensorReading.new(:sensor_id => user.hub.sensors[3].id,
                            :watthours => generate_dishwasher_reading)
      end
    end

    # re-queue the task after completing it
    self.delay(:run_at => 1.minute.from_now).generate_readings
  end

  # Note: staying away from UTC conversion for now, we'll see if I can get away
  # with that.
  def generate_computer_reading
    case Time.now.hour
    when 0..1
      200
    when 2..5
      100
    when 6..7
      200
    when 8..15
      100
    when 16..23
      275
    else
      0
    end
  end

  def generate_microwave_reading
    case Time.now.hour
    when 16..18
      if Time.now.min < 10
        1000
      end
    when 19
      if Time.now.min < 30
        1000
      end
    else
      0
    end
  end

  def generate_entertainment_reading
    case Time.now.hour
    when 16..20
      450
    else
      350
    end
  end

  def generate_dishwasher_reading
    case Time.now.hour
    when 10
      700
    when 22
      700
    else
      0
    end
  end
end
