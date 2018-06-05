class Jylis
  module DataType
    # A timestamped log.
    #
    # @see https://jemc.github.io/jylis/docs/types/tlog/
    class TLOG < Base
      # The result of a TLOG query.
      class Result
        include Enumerable

        # Construct a Result from a raw query result.
        #
        # @param query_result [Array]
        #
        # @return [Jylis::DataType::TLOG::Result]
        def self.parse(query_result)
          rows = query_result.reduce([]) do |memo, row|
            memo << Row.parse(row)
            memo
          end

          new(rows)
        end

        def initialize(rows)
          @rows = rows
        end

        # @return [Jylis::DataType::TLOG::Row] the row at the given index
        def [](index)
          @rows[index]
        end

        # :no doc:
        def each(&block)
          @rows.each(&block)
        end

        # @return [Integer] number of rows
        def count
          @rows.count
        end

        # Reconstruct the raw result returned by the database.
        def to_a
          @rows.map(&:to_a)
        end
      end

      # A row (data point) in a TLOG::Result.
      class Row
        attr_reader :value
        attr_reader :timestamp

        # Construct a Row from a raw query row.
        #
        # @param query_row [Array]
        #
        # @return [Jylis::DataType::TLOG::Row]
        def self.parse(query_row)
          new(query_row[0], query_row[1])
        end

        def initialize(value, timestamp)
          @value     = value
          @timestamp = timestamp
        end

        # :nodoc:
        def ==(other)
          other.value == self.value &&
          other.timestamp == self.timestamp
        end

        # Reconstruct the raw result returned by the database.
        def to_a
          [value, timestamp]
        end

        # @return [Time] the timestamp as a {Time} object
        def time
          Time.at(timestamp)
        end

        # @return [String] the timestamp as an ISO8601 formatted string
        def timestamp_iso8601
          time.utc.iso8601
        end
      end

      # Get the latest `value` and `timestamp` for the register at `key`.
      #
      # @return [Jylis::DataType::TLOG::Result]
      def get(key, count = nil)
        params = ["TLOG", "GET", key]

        params.push(count) if count

        result = connection.query(*params)

        Result.parse(result)
      end

      # # Set a `value` and `timestamp` for the register at `key`.
      # def set(key, value, timestamp)
        # result = connection.query("TLOG", "SET", key, value, timestamp)

        # unless result == "OK"
        #   raise "Failed: TLOG SET #{key} #{value} #{timestamp}"
        # end
      # end

      # Insert a `value`/`timestamp` entry into the log at `key`.
      def ins(key, value, timestamp)
        result = connection.query("TLOG", "INS", key, value, timestamp)

        unless result == "OK"
          raise "Failed: TLOG INS #{key} #{value} #{timestamp}"
        end
      end

      # @return [Integer] the number of entries in the log at `key`
      def size(key)
        connection.query("TLOG", "SIZE", key)
      end

      # @return [Integer] the current cutoff timestamp of the log at `key`
      def cutoff(key)
        connection.query("TLOG", "CUTOFF", key)
      end

      # Raise the cutoff timestamp of the log, causing any entries to be
      # discarded whose timestamp is earlier than the newly given `timestamp`.
      def trimat(key, timestamp)
        result = connection.query("TLOG", "TRIMAT", key, timestamp)

        unless result == "OK"
          raise "Failed: TLOG TRIMAT #{key} #{timestamp}"
        end
      end

      # Raise the cutoff timestamp of the log to retain at least `count`
      # entries, by setting the cutoff timestamp to the timestamp of the entry
      # at index `count - 1` in the log. Any entries with an earlier timestamp
      # than the entry at that index will be discarded. If `count` is zero,
      # this is the same as calling #clr.
      def trim(key, count)
        result = connection.query("TLOG", "TRIM", key, count)

        unless result == "OK"
          raise "Failed: TLOG TRIM #{key} #{count}"
        end
      end

      # Raise the cutoff timestamp to be the timestamp of the latest entry plus
      # one, such that all local entries in the log will be discarded due to
      # having timestamps earlier than the cutoff timestamp.
      def clr(key)
        result = connection.query("TLOG", "CLR", key)

        unless result == "OK"
          raise "Failed: TLOG CLR #{key}"
        end
      end
    end
  end
end
