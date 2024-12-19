module GenerateCalendar
  def generate_calendar(month, year)
    start_at = Date.new(year, month, 1)
    end_at = Date.new(year, month, -1)
    start_wday = start_at.wday
    start_wday = (start_wday.zero? ? 6 : start_wday - 1)
    current_day = 1
    calendar = Array.new(6) { Array.new(7, '  ') }

    (0..5).each do |week|
      (0..6).each do |day|
        if week == 0 && day < start_wday
          next
        elsif current_day > end_at.day
          break
        end

        calendar[week][day] = current_day.to_s.rjust(2)
        current_day += 1
      end
    end
    calendar
  end
end