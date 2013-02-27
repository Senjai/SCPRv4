module DatePathHelper
  def date_path(date)
    { year: date.year.to_s, month: "%02d" % date.month, day: "%02d" % date.day }
  end
end
