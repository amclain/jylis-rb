class Jylis
  module DataType
    # A timestamped register.
    #
    # @see https://jemc.github.io/jylis/docs/types/treg/
    class TREG < Base
      # The result of a TREG query.
      class Result
        attr_reader :value
        attr_reader :timestamp

        # Construct a Result from a raw query result.
        #
        # @param query_result [Array]
        #
        # @return [Jylis::DataType::TREG::Result]
        def self.parse(query_result)
          new(query_result[0], query_result[1])
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
      # @return [Jylis::DataType::TREG::Result]
      def get(key)
        result = connection.query("TREG", "GET", key)

        Result.parse(result)
      end

      # Set a `value` and `timestamp` for the register at `key`.
      #
      # @param timestamp [Integer, String] a unix or iso8601 formatted timestamp
      def set(key, value, timestamp)
        timestamp = Time.parse(timestamp).utc.to_i if timestamp.is_a?(String)
        result    = connection.query("TREG", "SET", key, value, timestamp)

        unless result == "OK"
          raise "Failed: TREG SET #{key} #{value} #{timestamp}"
        end
      end
    end
  end
end
