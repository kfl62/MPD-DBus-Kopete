#!/usr/bin/ruby -w
#
# This is the simple way, without mpd dbus
# Usage:
# ruby -C ~/work/mpd-dbus-kopete/lib ~/work/mpd-dbus-kopete/lib/mpd2kopete.rb > ~/log/listen.log &
# where ~/work/mpd-dbus-kopete/lib is the location of file and I usually want to know
# what's happening :) > ~/log/listen.log
#

require 'librmpd2/librmpd'
require 'dbus'
require 'thread'

class MPD2Kopete

	def initialize
		@mpd = MPD.new
		@mpd.register_callback( self.method('song_cb'), MPD::CURRENT_SONG_CALLBACK )
	end

	def start
		puts "Starting MPD2Kopete \n"
		@mpd.connect true
		t = Thread.new do
			gets
		end

		t.join
	end

	def stop
		puts "Shutting Down MPD2Kopete"
		@mpd.disconnect true
	end

	def song_cb( current )
		if not current.nil?
      msg = beutify_msg(current)
      p msg
			kopete(msg)
		else
			kopete("Unknown")
		end
	end

  def kopete(msg)
    d = DBus::SessionBus.instance
    o = d.service("org.kde.kopete").object("/Kopete")
    o.introspect
    @i = o["org.kde.Kopete"]
    @i.setStatusMessage msg
  end

  def beutify_msg(o)
    if o.file.include?("http://")
      msg = ""
      if o.name.nil?
        msg += "...?..."
      elsif o.name.include?("More Fm")
        more_fm = o.title.split(" - ")
        msg += more_fm[1] + " by " + more_fm[0] + " on More FM"
      elsif o.name.index(/Paprika|EuropaFM|Sláger/)
        msg += o.name
      else
        o.title.nil? ? msg += "...?..." : msg += o.title
        msg += " on " + o.name
      end
    end
  end
end
client = MPD2Kopete.new
client.start
