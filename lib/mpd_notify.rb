#!/usr/bin/ruby -w
require 'dbus'

def beutify_txt(var)
  txt = "Unknown"
  if var.nil?
    exit
  end
  # I can't figure out how to transfer an object on dbus, so I need to transform
  # a string, result from object.inspect, to a hash, for better readability.
  # Google was my friend ...
  # Posted by Maciej Tomaka on http://www.ruby-forum.com/topic/161977
  s = var.to_s.match(/^\s*\{\s*(.+)\}\s*$/).captures.first;
  h = Hash[*s.scan(/\"([^"]*)\"\s*=>\s*\"([^"]*)\"/).flatten]
  # Parse hash most of streams don't send mpd readable data :(
  #
  if h["file"].include?("http://")
    txt = "Listening "
    h["title"].nil? ? txt += "Unknown" : txt += h["title"]
    txt += " on "
    h["name"].nil? ? txt += "Unknown" : txt += h["name"].split(" -")[0]
  end
  return txt
end

# query mpd's dbus
mpd_bus = DBus::SessionBus.instance
mpd_service = mpd_bus.service("org.freedesktop.mpd")
mpd = mpd_service.object("/")
mpd.introspect
mpd.default_iface = ("org.freedesktop.MPD")
# connect to kopete's dbus
kopete_bus = DBus::SessionBus.instance
kopete_service = kopete_bus.service("org.kde.kopete")
kopete = kopete_service.object("/Kopete")
kopete.introspect
kopete.default_iface = ("org.kde.Kopete")
# notify kopete on song change
mpd.on_signal("trackInfo") do
  kopete.setStatusMessage beutify_txt(mpd.getAll)
end

main = DBus::Main.new
main << mpd_bus
main.run



