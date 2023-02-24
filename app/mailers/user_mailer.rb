class UserMailer < ApplicationMailer

  def welcome
    @greeting = "Hi"

    mail to: "kevin.hoffman.france@gmail.com"
  end
end
