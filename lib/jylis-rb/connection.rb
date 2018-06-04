require "hiredis"

class Jylis
  # A connection to the database.
  class Connection
    # The server URI schema is not supported.
    class UnsupportedSchemaError < StandardError; end
    # The host is missing from the server URI.
    class HostMissingError < StandardError; end

    # @param server_uri [URI, String] uri of the server to connect to
    #
    # @raise [UnsupportedSchemaError] if the server URI schema is not supported
    # @raise [HostMissingError] if the host is missing from the server URI
    def initialize(server_uri)
      server_uri = URI.parse(server_uri) unless server_uri.is_a?(URI)

      unless server_uri.scheme.downcase == "jylis"
        raise UnsupportedSchemaError.new(
          "#{server_uri.scheme} is not a supported schema"
        )
      end

      unless server_uri.host
        raise HostMissingError.new("No host specified")
      end

      @server_host = server_uri.host
      @server_port = server_uri.port || 6379
      @connection  = Hiredis::Connection.new

      connect
    end

    # @return [Boolean] true if a connection to the server is established
    def connected?
      @connection.connected?
    end

    # Reconnect to the server.
    def reconnect
      disconnect if connected?

      connect
    end

    # Disconnect from the server.
    def disconnect
      @connection.disconnect
    end

    # Make a query to the database.
    #
    # @param args data type function args. Can be an args list or array.
    #
    # @return [Array] query response
    #
    # @see https://jemc.github.io/jylis/docs/types/
    def query(*args)
      if args.count == 1 && args.first.is_a?(Array)
        args = *args.first
      end

      @connection.write(args)
      @connection.read
    end

    # TREG functions
    #
    # @return [Jylis::DataType::TREG]
    def treg
      @treg ||= Jylis::DataType::TREG.new(self)
    end

    # TLOG functions
    #
    # @return [Jylis::DataType::TLOG]
    def tlog
      @tlog ||= Jylis::DataType::TLOG.new(self)
    end

    # GCOUNT functions
    #
    # @return [Jylis::DataType::GCOUNT]
    def gcount
      @gcount ||= Jylis::DataType::GCOUNT.new(self)
    end

    # PNCOUNT functions
    #
    # @return [Jylis::DataType::PNCOUNT]
    def pncount
      @pncount ||= Jylis::DataType::PNCOUNT.new(self)
    end

    # MVREG functions
    #
    # @return [Jylis::DataType::MVREG]
    def mvreg
      @mvreg ||= Jylis::DataType::MVREG.new(self)
    end

    # UJSON functions
    #
    # @return [Jylis::DataType::UJSON]
    def ujson
      @ujson ||= Jylis::DataType::UJSON.new(self)
    end

    private

    # Connect to the server.
    def connect
      @connection.connect(@server_host, @server_port)
    end
  end
end
