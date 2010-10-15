# encoding: utf-8

class String
  def titleize
    split(/(\W)/).map(&:capitalize).join
  end
end

class History < Logger
  def format_message(severity, datetime, progname, msg)
    "[%s %s] - %s\n" % [ severity, datetime.strftime("%Y-%m-%d %H:%M"), msg ]
  end

  def log?
    CfgHandler.log?
  end
end

