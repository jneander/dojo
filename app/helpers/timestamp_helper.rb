module TimestampHelper

  def datetime_to_date_and_time(datetime)
    datetime.strftime('%B %-d, %Y at %l:%M%P')
  end

end
