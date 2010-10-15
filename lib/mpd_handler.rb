# encoding: utf-8

class MpdHandler
  include KptHandler
  include MsgHandler

  def initialize
    @mpd = MPD.new
    @mpd.register_callback( self.method('song_cb'), MPD::CURRENT_SONG_CALLBACK )
    log_path = File.join(CfgHandler.base_dir,CfgHandler.log_path) rescue $stdout
    @log = History.new(log_path)
  end

  def start
    @log.info "Start logging mpd..." if@log.log?
    @mpd.connect true
    @t = Thread.new {sleep}
    @t.join
  end

  def stop
    @mpd.disconnect
    @log.info "Bye! Bye!" if@log.log?
    @log.close
  end

  def song_cb(current)
    msg = beutify(current)
    set_status_message(msg) unless CfgHandler.log_only
    msg += set_log_message
    is_running? ? @log.info(msg) : @log.warn(msg)  if@log.log?
  end

end

