class Jylis
  module DataType
    # A multi-value register.
    #
    # @see https://jemc.github.io/jylis/docs/types/mvreg/
    class MVREG < Base

      # Get the latest value(s) for the register at `key`.
      def get(key)
        connection.query("MVREG", "GET", key)
      end

      # Set the latest `value` for the register at `key`.
      def set(key, value)
        result = connection.query("MVREG", "SET", key, value)

        unless result == "OK"
          raise "Failed: MVREG SET #{key} #{value}"
        end
      end
    end
  end
end
