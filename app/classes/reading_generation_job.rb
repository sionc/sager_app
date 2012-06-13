class ReadingGenerationJob
  # mandatory enqueued job method
  def perform
    ReadingGenerationJob.gen_readings Time.now, true
  end

  #
  # Given a Time object, will generate four readings for that minute
  #
  def self.gen_readings(time, requeue)
    rand_factor = 1
    case time.day % 5
    when 0
      rand_factor = 5
    when 1
      rand_factor = 3
    when 2
      rand_factor = 7
    when 3
      rand_factor = 2
    when 4
      rand_factor = 1
    end

    demo_users = User.where({ :demo => true })

    demo_users.each do |user|
      # hack: for demo purposes, you have to have 4 sensors for generation to
      #   work as intended
      if !user.hub.nil? &&
        !user.hub.sensors.nil? &&
        user.hub.sensors.count == 4

        SensorReading.create(:sensor_id => user.hub.sensors[0].id,
                             :watthours => ReadingGenerationJob.gen_computer_reading(time) * rand_factor,
                             :created_at => time)
        SensorReading.create(:sensor_id => user.hub.sensors[1].id,
                             :watthours => ReadingGenerationJob.gen_microwave_reading(time) * rand_factor,
                             :created_at => time)
        SensorReading.create(:sensor_id => user.hub.sensors[2].id,
                             :watthours => ReadingGenerationJob.gen_entertainment_reading(time) * rand_factor,
                             :created_at => time)
        SensorReading.create(:sensor_id => user.hub.sensors[3].id,
                             :watthours => ReadingGenerationJob.gen_dishwasher_reading(time) * rand_factor,
                             :created_at => time)
      end
    end

    # re-queue the task after completing it, if requeue is true
    self.delay(:run_at => 1.minute.from_now).gen_readings Time.now if requeue
  end

  #
  # Given start and end Time objects, will generate readings once a minute
  # for each of the four sensors
  # Useful for pre-populating database
  #
  def self.gen_readings_period(time_start, time_end)
    # do everythign in one transaction to save a little bit of time (not much)
    ActiveRecord::Base.transaction do
      total_minutes = ((time_end - time_start)/60).floor
      (0..total_minutes).each do |min|
        ReadingGenerationJob.gen_readings(time_start + min*60, false)
      end
    end
  end

  private

  # def self.perturb(wh_value)
  #   perturbed_wh_value = wh_value + rand(-10..10)
  #   perturbed_wh_value >= 0 ? perturbed_wh_value : 0
  # end

  # Note: staying away from UTC conversion for now, we'll see if I can get away
  # with that.
  def self.gen_computer_reading(time)
    wh_value = 0
    case time.hour
    when 0..1
      wh_value = 200
    when 2..5
      wh_value = 100
    when 6..7
      wh_value = 200
    when 8..15
      wh_value = 100
    when 16..23
      wh_value = 275
    else
      wh_value = 0
    end

    # ReadingGenerationJob.perturb wh_value
  end

  def self.gen_microwave_reading(time)
    wh_value = 0
    case time.hour
    when 16..18
      if time.min < 10
        wh_value = 1000
      else
        wh_value = 0
      end
    when 19
      if time.min < 30
        wh_value = 1000
      else
        wh_value = 0
      end
    else
      wh_value = 0
    end

    # ReadingGenerationJob.perturb wh_value
  end

  def self.gen_entertainment_reading(time)
    case time.hour
    when 16..20
      wh_value = 450
    else
      wh_value = 350
    end

    # ReadingGenerationJob.perturb wh_value
  end

  def self.gen_dishwasher_reading(time)
    case time.hour
    when 10
      wh_value = 700
    when 22
      wh_value = 700
    else
      wh_value = 0
    end

    # ReadingGenerationJob.perturb wh_value
  end
end
