require_relative "version" # Version reopens this class.

# Jylis database adapter.
class Jylis
  class << self
    # The current connection.
    attr_accessor :current
  end
end
