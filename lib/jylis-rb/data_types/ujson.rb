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

        Oj.load(result)
      end

      # Store the given `ujson` data at the given `key`.
      #
      # @overload set(*keys, value)
      def set(*args)
        unless args.count >= 2
          raise ArgumentError.new("Must provide at least one key and the value")
        end

        value = args.pop
        keys  = args

        params = ["UJSON", "SET"] + keys
        params.push Oj.dump(value)

        result = connection.query(*params)

        unless result == "OK"
          raise "Failed: UJSON SET #{params.join(' ')}"
        end
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
        unless args.count >= 2
          raise ArgumentError.new("Must provide at least one key and the value")
        end

        value = args.pop
        keys  = args

        params = ["UJSON", "INS"] + keys
        params.push Oj.dump(value)

        result = connection.query(*params)

        unless result == "OK"
          raise "Failed: UJSON INS #{params.join(' ')}"
        end
      end

      # Remove the specified `value` from the set of values stored at `key`.
      #
      # @overload rm(*keys, value)
      def rm(*args)
        unless args.count >= 2
          raise ArgumentError.new("Must provide at least one key and the value")
        end

        value = args.pop
        keys  = args

        params = ["UJSON", "RM"] + keys
        params.push Oj.dump(value)

        result = connection.query(*params)

        unless result == "OK"
          raise "Failed: UJSON RM #{params.join(' ')}"
        end
      end
    end
  end
end
