#!/usr/bin/ruby -w
  require 'dbus'
  require 'thread'
  require 'librmpd2/librmpd'
  Thread.abort_on_exception = true

  @@name, @@title, @@file, @@all = ""
  #mpd dbus introspectable
  class DBusIntrospectable < DBus::Object
    dbus_interface("org.freedesktop.DBus.Introspectable") do
      dbus_method :Introspect do

      end
    end

  end
  #our scope is to notify not to control, so methods...
  class MpdBus < DBus::Object
    dbus_interface "org.freedesktop.MPD" do
      dbus_method :getName, "out name_out:s" do
        @@name
      end
      dbus_method :getTitle, "out title_out:s" do
        @@title
      end
      dbus_method :getFile, "out file_out:s" do
        @@file
      end
      dbus_method :getAll, "out all_out:s" do
        @@all
      end
      dbus_signal :trackInfo, "track:s"
    end
  end
  #register dbus
  bus = DBus.session_bus
  service = bus.request_service("org.freedesktop.mpd")
  dbus_introspectable = DBusIntrospectable.new("/")
  @@mpd_bus = MpdBus.new("/")
  service.export(dbus_introspectable)
  service.export(@@mpd_bus)
  #get info from mpd
  class MpdClient
    def song_cb( current )
      if not current.nil?
#        puts "Current Song: #{current.inspect}"
        @@mpd_bus.trackInfo("Changed")
        current.name.nil? ? @@name = "Unknown" : @@name = current.name
        current.title.nil? ? @@title = "Unknown" : @@title = current.title
        current.file.nil? ? @@file = "Unknown" : @@file = current.file
        @@all = current.inspect
        return @@name, @@title, @@file, @@all
      else
 #       puts "Current Song: nil"
        @@mpd_bus.trackInfo("nil")
      end
    end
  end
  #watch mpd (callback)
  t = Thread.new do
    mpd = MpdClient.new
    mpd_sess = MPD.new
    mpd_sess.register_callback( mpd.method('song_cb'), MPD::CURRENT_SONG_CALLBACK )
    mpd_sess.connect(true)
   gets
  end
  #run
  main = DBus::Main.new
  main << bus
  main.run
