module EventsHelper
  def format_time(date_time)
    date_time.strftime("%B %-d, %Y, %I:%M %p")
  end

  def format_cost(cost)
    if cost > 0
      number_to_currency(cost)
    else
      "Free"
    end
  end

  def format_url(url)
    if url.present?
      "<a href='<%= url %>' target='_blank'>#{url}</a>".html_safe
    else
      "No URL"
    end
  end
end
