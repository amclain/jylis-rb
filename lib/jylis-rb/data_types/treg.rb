class Jylis
  module DataType
    # A timestamped register.
    #
    # @see https://jemc.github.io/jylis/docs/types/treg/
    class TREG < Base
      # Get the latest `value` and `timestamp` for the register at `key`.
      #
      # @return [Hash]
      def get(key)
        result = connection.query("TREG", "GET", key)

        {value: result[0], timestamp: result[1]}
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
