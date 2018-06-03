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
      end

      # Get the latest `value` and `timestamp` for the register at `key`.
      #
      # @return [Jylis::DataType::TREG::Result]
      def get(key)
        result = connection.query("TREG", "GET", key)

        Result.parse(result)
      end

      # Set a `value` and `timestamp` for the register at `key`.
      def set(key, value, timestamp)
        result = connection.query("TREG", "SET", key, value, timestamp)

        unless result == "OK"
          raise "Failed: TREG SET #{key} #{value} #{timestamp}"
        end
      end
    end
  end
end
