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
  end

  def set_log_message
    retval = " - StatusMessage updated"
    retval = " - KopeteError 'not running'" unless is_running?
    return retval
  end

end
