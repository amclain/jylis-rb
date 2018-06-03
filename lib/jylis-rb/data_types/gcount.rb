class Jylis
  module DataType
    # A grow-only counter.
    #
    # @see https://jemc.github.io/jylis/docs/types/gcount/
    class GCOUNT < Base
      # Get the resulting `value` for the counter at `key`.
      #
      # @return [Integer]
      def get(key)
        connection.query("GCOUNT", "GET", key)
      end

      # Increase the counter at `key` by the amount of `value`.
      def inc(key, value)
        result = connection.query("GCOUNT", "INC", key, value)

        unless result == "OK"
          raise "Failed: GCOUNT INC #{key} #{value}"
        end
      end
    end
  end
end
