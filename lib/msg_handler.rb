# encoding: utf-8

module MsgHandler

  def beutify(song)
    is_stream(song) ? stream(song) : album(song)
  end

  def is_stream(song)
    song.file.include?("http://")
  end

  def stream(song)
    msg = "...?.." if song.name.nil?
    case song.name
    when /More Fm/
      stream = "More Fm"
      artist, title = song.title.split(" - ")
      title = "News" if artist == "FSNHeadlines"
      msg = message(title,artist,stream)
    when /Retro Radio Csikszereda/
      stream = "Retro Radio"
      artist, title = song.title.split(" - ")
      msg = message(title,artist,stream)
    when /ProFM/
      stream = song.name
      title, artist = song.title.match(/(.*)\((.*)\)/).captures
      msg = message(title.titleize,artist.titleize,stream)
    when /Paprika|EuropaFM|Sláger/
      msg = song.name
    else
      msg = "...?..."
    end
    return msg
  end

  def album(song)
    return "album"
  end

  def message(title,artist,album)
    begin
      msg = [title,"by",artist,"on",album].join(" ")
    rescue Exception => e
      msg = "...?... Some error -> '#{e.message}'"
    end
  end

end

