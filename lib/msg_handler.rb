# encoding: utf-8

module MsgHandler

  def beutify(song)
    is_stream(song) ? stream(song) : album(song)
  end

  def is_stream(song)
    song.file.include?("http://")
  end

  def stream(song)
    case song.name
    when /More Fm/
      stream = "More Fm"
      artist, title = song.title.split(" - ")
      title = "News" if artist == "FSNHeadlines"
      msg = message(title,artist,stream)
    when /Retro Radio Csikszereda/
      stream = "Retro Radio"
      if song.title.nil? || song.title.empty?
        title = artist = "...?..."
      else
        artist, title = song.title.split(" - ")
      end
      msg = message(title,artist,stream)
    when /ProFM/
      stream = song.name
      if song.title.nil? || song.title.empty?
        title = artist = "...?..."
      else
        title, artist = song.title.match(/(.*)\((.*)\)/).captures
      end
      msg = message(title,artist,stream)
    else
      msg = "...?..."
      msg = song.name unless song.name.nil? || song.name.empty?
    end
    return msg
  end

  def album(song)
    date = "~#{song.date}~" || nil
    msg = message(song.title,song.artist,song.album,date)
    return msg
  end

  def message(title,artist,album,date=nil)
    title = title.titleize.strip
    artist = artist.titleize.strip
    album = album.strip
    msg = [title,"by",artist,"on",album,date].join(" ")
  end

end

