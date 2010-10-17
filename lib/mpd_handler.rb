# encoding: utf-8

class MpdHandler
  include KptHandler
  include MsgHandler

  def initialize
    @mpd = MPD.new
    @mpd.register_callback(self.method('song_cb'), MPD::CURRENT_SONG_CALLBACK)
    @mpd.register_callback(self.method('state_cb'), MPD::STATE_CALLBACK)
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
    if current
      msg = beutify(current)
      unless msg.include?("...?...")
        set_status_message(msg) unless CfgHandler.log_only
      end
      msg += set_log_message
      is_running? ? @log.info(msg) : @log.warn(msg)  if@log.log?
    else
      set_status_message("Listening to nothing, just working...") unless CfgHandler.log_only
      @log.error("MPD is running, but not playing...")
    end
  end
  
  def state_cb(state)
    if state == "stop"
      set_status_message("Listening to nothing, just working...") unless CfgHandler.log_only
      @log.info("MPD is running, but stopped...")
    end
  end
end

