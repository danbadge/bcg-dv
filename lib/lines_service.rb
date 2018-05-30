require 'csv'

class LinesService
  def lines_in_position_at_time(x, y, timestamp)
    stop_ids = stop_ids_at_position(x, y)

    line_ids = line_ids_at_stops_and_time(stop_ids, timestamp)

    filter_lines_by(line_ids).map { |line|
      {
        :id => line['line_id'],
        :name => line['line_name'],
      }
    }
  end

  def delay(name)
    line = read_csv('data/delays.csv')
      .find { |l| l['line_name'] == name.upcase }

    return nil if line.nil?

    {
      :name => line['line_name'],
      :delay_in_minutes => line['delay']
    }
  end

  private

  def stop_ids_at_position(x, y)
    stops = read_csv('data/stops.csv')

    stops_at_position = stops.select { |stop|
      stop['x'] == x.to_s && stop['y'] == y.to_s
    }

    stops_at_position.map { |stop|
      stop['stop_id']
    }
  end

  def line_ids_at_stops_and_time(stop_ids, timestamp)
    stop_times = read_csv('data/stop_times.csv')

    stops_at_time_with_id = stop_times.select { |times|
      stop_ids.include?(times['stop_id']) && times['time'] == timestamp
    }

    stops_at_time_with_id.map { |times| times['line_id'] }
  end

  def filter_lines_by(line_ids)
    all_lines = read_csv('data/lines.csv')

    all_lines.select { |line| line_ids.include?(line['line_id']) }
  end

  def read_csv(file)
    CSV.read(file, :headers => true)
  end
end
