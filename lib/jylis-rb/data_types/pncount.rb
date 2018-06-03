class Jylis
  module DataType
    # A positive/negative counter.
    #
    # @see https://jemc.github.io/jylis/docs/types/pncount/
    class PNCOUNT < Base
      # Get the resulting `value` for the counter at `key`.
      #
      # @return [Integer]
      def get(key)
        connection.query("PNCOUNT", "GET", key)
      end

      # Increase the counter at `key` by the amount of `value`.
      def inc(key, value)
        result = connection.query("PNCOUNT", "INC", key, value)

        unless result == "OK"
          raise "Failed: PNCOUNT INC #{key} #{value}"
        end
      end

      # Decrease the counter at `key` by the amount of `value`.
      def dec(key, value)
        result = connection.query("PNCOUNT", "DEC", key, value)

        unless result == "OK"
          raise "Failed: PNCOUNT DEC #{key} #{value}"
        end
      end
    end
  end
end
