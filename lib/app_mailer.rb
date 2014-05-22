require 'cgi'

class AppMailer < ActionMailer::Base
  default from: ENV['MAIL_FROM'], to: ENV['MAIL_TO']
  helper Twitter::Autolink

  def url_options; end

  def hour time_to, lang: :ja
    @time_from = time_to - 1.hour
    @conversations = Conversation.during_hour_to(time_to).lang(lang).by_priority
    mail(
      subject: "Conversations at #{@time_from.getlocal.strftime('%H on %b %d')}",
    )
  end

  def day date, lang: :ja
    @date = date
    @conversations = Conversation.during_day_on(@date).lang(lang).by_priority.limit(100)
    mail(
      subject: "Top Conversations on #{@date.strftime('%b %d')}",
    )
  end

  private
  def _normalize_layout value
    value
  end
end
