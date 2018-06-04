require "oj"

Oj.default_options = {mode: :compat}

class Jylis
  module DataType
    # Unordered JSON.
    #
    # @see https://jemc.github.io/jylis/docs/types/ujson/
    class UJSON < Base
      # Get the JSON representation of the data currently held at `key`.
      def get(*keys)
        unless keys.count >= 1
          raise ArgumentError.new("Must provide at least one key")
        end

        params = ["UJSON", "GET"] + keys

        result = connection.query(*params)

        result == "" ? result : Oj.load(result)
      end

      # Store the given `ujson` data at the given `key`.
      #
      # @overload set(*keys, value)
      def set(*args)
        key_value_query(__method__, *args)
      end

      # Remove all data stored at or under the given `key`.
      def clr(*keys)
        unless keys.count >= 1
          raise ArgumentError.new("Must provide at least one key")
        end

        params = ["UJSON", "CLR"] + keys

        result = connection.query(*params)

        unless result == "OK"
          raise "Failed: UJSON CLR #{params.join(' ')}"
        end
      end

      # Insert the given `value` as a new element in the set of values stored
      # at `key`.
      #
      # @overload ins(*keys, value)
      def ins(*args)
        key_value_query(__method__, *args)
      end

      # Remove the specified `value` from the set of values stored at `key`.
      #
      # @overload rm(*keys, value)
      def rm(*args)
        key_value_query(__method__, *args)
      end

      private

      # Execute a query consisting of (*keys, value) that returns "OK" on success.
      #
      # @param function [String, Symbol] the Jylis function name
      # @param args [Array] the list of keys, with the value last
      def key_value_query(function, *args)
        unless args.count >= 2
          raise ArgumentError.new("Must provide at least one key and the value")
        end

        function = function.to_s.upcase
        value    = args.pop
        keys     = args

        params = ["UJSON", function] + keys
        params.push Oj.dump(value)

        result = connection.query(*params)

        unless result == "OK"
          raise "Failed: UJSON #{function} #{params.join(' ')}"
        end
      end
    end
  end
end
