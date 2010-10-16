# encoding: utf-8
require "ostruct"

CfgHandler = OpenStruct.new(
  :base_dir   => "#{ENV["HOME"]}/.mpd2kopete",
  :log?       => true,
  :log_path   => "mpd_history.log",
  :log_only   => false,
  :daemon_pid => "mpd2kopete.pid",
  :daemon_log => "mpd2kopete_daemon.log"
)

