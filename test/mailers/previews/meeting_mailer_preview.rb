# Preview all emails at http://localhost:3000/rails/mailers/meeting_mailer
class MeetingMailerPreview < ActionMailer::Preview

    def invite
       MeetingMailer.with(meeting: Meeting.first).invite
    end 

end
