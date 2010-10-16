# encoding: utf-8

module KptHandler

  def is_running?
    d = DBus::SessionBus.instance
    d.service("org.kde.kopete").exists?
  end

  def set_status_message(msg)
    if is_running?
      d = DBus::SessionBus.instance
      o = d.service("org.kde.kopete").object("/Kopete")
      o.introspect
      i = o["org.kde.Kopete"]
      i.setStatusMessage msg
    end
    rescue Exception => e
      set_log_message(e.message)
  end

  def set_log_message(msg=nil)
    retval = " - KopeteOK"
    retval = " - KopeteOff" unless is_running?
    retval = " - KopeteError '#{msg}'" unless msg.nil?
    return retval
  end

end
