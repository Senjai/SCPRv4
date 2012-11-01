module StubTime
  def freeze_time_at(time)
    time = time.is_a?(Time) ? time : Chronic.parse(time.to_s)
    Time.stub(:now) { time }
    time
  end
end
