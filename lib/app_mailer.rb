require 'cgi'

class AppMailer < ActionMailer::Base
  default from: ENV['MAIL_FROM'], to: ENV['MAIL_TO']
  helper Twitter::Autolink

  def url_options; end

  def hourly to_time
    @to_time = to_time
    @conversations = Conversation.only_1hour(@to_time).lang(:ja).by_priority
    mail(
      subject: "Conversations at #{@to_time.getlocal.strftime('%H on %b %d')}",
    )
  end

  private
  def _normalize_layout value
    value
  end
end
