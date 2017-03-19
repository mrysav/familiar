module DateHelper
    def render_short_date(date)
        return date.strftime("%B %-d, %Y") if date
    end

    def render_long_datetime(date)
        return date.strftime("%B %-d, %Y; %l:%M %p") if date
    end
end