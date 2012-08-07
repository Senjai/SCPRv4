module StubTime
  def freeze_time_at(time)
    time = Chronic.parse(time)
    Time.stub(:now) { time }
  end
end
