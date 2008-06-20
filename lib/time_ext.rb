class Time
  def w3c
    utc.strftime("%Y-%m-%dT%H:%M:%S+00:00")
  end
end