desc "This task is called by the Heroku scheduler add-on"
task :meetings_reminders => :environment do
  puts "Sending meetings reminders..."
 
    @meetings_a_venir = Meeting.where(
        "start_time > ?", Time.now)

    @meetings_h24 = Meeting.where(
        "start_time = ?", Date.tomorrow)

    @meetings_h24.each do | meeting | 
        MeetingMailer.with(meeting: meeting)
            .reminder(meeting).deliver_now
    end

  puts "done."
end
