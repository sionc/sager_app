namespace :polarmeter do
  namespace :seed do
    desc "Generates back a week worth of sensor readings from Time.now"
    task :week => :environment do
      ReadingGenerationJob.gen_readings_period(Time.now - (60*60*24*7),
                                               Time.now)
    end
  end
end
