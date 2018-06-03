class Jylis
  # Namespace for Jylis data types.
  #
  # @see https://jemc.github.io/jylis/docs/types/
  module DataType
    # A base data type for others to inherit shared logic from.
    # This class can't be instantiated directly.
    class Base
      # The Jylis::Connection to use for queries.
      attr_reader :connection

      # @param connection [Jylis::Connection] connection to use for queries
      def initialize(connection)
        if self.class == Base
          raise "Base is an abstract class and must be inherited"
        end

        raise ArgumentError.new("Connection can't be nil") unless connection

        @connection = connection
      end
    end
  end
end
