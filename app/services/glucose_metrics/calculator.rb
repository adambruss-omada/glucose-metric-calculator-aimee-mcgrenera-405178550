module GlucoseMetrics
  class Calculator
    attr_reader :member

    def initialize(member:)
      @member = member
    end

    def metrics_for(period)
      readings = member.glucose_levels
      return {} if readings.empty?

      range = time_range(period)

      readings_in_period = readings.select do |r|
        local_tested_at = local_time_with_offset(r.tested_at, r.tz_offset)
        range.cover?(local_tested_at)
      end

      return {} if readings_in_period.empty?

      values = readings_in_period.map(&:value)
      above = values.count { |v| v > 180 }
      below = values.count { |v| v < 70 }

      {
        average: (values.sum / values.size.to_f).round(2),
        above_range: ((above.to_f / values.size) * 100).round(2),
        below_range: ((below.to_f / values.size) * 100).round(2),
        count: values.size
      }
    end

    def changes(period)
      # not working
      case period
      when :last_7_days
        metric_change(:last_7_days, :previous_week)
      when :this_month
        metric_change(:this_month, :last_month)
      else
        {}
      end
    end

    private

    def time_range(period)
      today_utc = Time.now.utc.beginning_of_day

      case period
      when :last_7_days
        (today_utc - 6.days)..(today_utc.end_of_day)
      when :previous_week
        (today_utc - 13.days)..(today_utc - 7.days).end_of_day
      when :this_month
        today_utc.beginning_of_month..today_utc.end_of_month
      when :last_month
        (today_utc - 1.month).beginning_of_month..(today_utc - 1.month).end_of_month
      else
        raise ArgumentError, "Unknown period: #{period}"
      end
    end

    def local_time_with_offset(utc_time, tz_offset)
        hours, minutes = tz_offset.split(':').map(&:to_i)
        offset_seconds = (hours * 60 + minutes) * 60
        offset_seconds = -offset_seconds if tz_offset.start_with?('-')
        utc_time + offset_seconds
    end

    def metric_change(current_period, previous_period)
      current = metrics_for(current_period)
      previous = metrics_for(previous_period)

      return {} if current.empty? || previous.empty?

      {
        average: (current[:average] - previous[:average]).round(2),
        above_range: (current[:above_range] - previous[:above_range]).round(2),
        below_range: (current[:below_range] - previous[:below_range]).round(2)
      }
    end
  end
end
