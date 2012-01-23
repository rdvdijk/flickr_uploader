# Monkeypatch
class ProgressBar

  def fmt_count
    @title = "#{@current}/#{@total} [#{speed}kb/s]"
    @title_width = 24
    fmt_title
  end

  def speed=(speed)
    @speed = speed
  end

  def speed
    @speed || 0
  end

end
