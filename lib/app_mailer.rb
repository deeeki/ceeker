require 'cgi'

class AppMailer < ActionMailer::Base
  default from: ENV['MAIL_FROM'], to: ENV['MAIL_TO']
  helper Twitter::Autolink

  def url_options; end

  def hourly from
    @from = from
    @to = @from + 1.hour
    @conversations = Conversation.where(:created_at.gte => @from, :created_at.lt => @to)
    mail(
      subject: "Conversations at #{@from.getlocal.strftime('%H on %b %d')}",
    )
  end

  private
  def _normalize_layout value
    value
  end
end
