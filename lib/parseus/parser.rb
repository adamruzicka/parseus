require 'parseus/parser/combinator'
require 'parseus/parser/parsers'

module Parseus
  class Parser
    extend Parsers
    extend Combinator

    attr_reader :failure_message
    def initialize(failure_message = nil, &block)
      @failure_message = failure_message
      @parser = block
    end

    def run(input)
      @parser.call(input, self)
    end

    def map(&block)
      self.class.map(self, &block)
    end

    def many
      self.class.many(self)
    end

    def some
      self.class.some(self)
    end

    def discard_left(other)
      self.class.discard_left(self, other)
    end
    alias < discard_left

    def discard_right(other)
      self.class.discard_right(self, other)
    end
    alias > discard_right

    def and_then(other)
      self.class.and_then(self, other)
    end
    alias & and_then

    def or(other)
      self.class.or(self, other)
    end
    alias | or

    def exactly(count)
      self.class.exactly(self, count)
    end
  end
end
