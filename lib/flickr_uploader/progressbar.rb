# Monkeypatch
class ProgressBar

  def fmt_count
    @title = "#{@current}/#{@total}"
    fmt_title
  end

end
