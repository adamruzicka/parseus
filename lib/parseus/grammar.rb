module Parseus
  class Grammar
    include Parser::Parsers
    include Parser::Combinator

    attr_reader :root
    def initialize(&block)
      @rules = {}
      @root = nil
      instance_eval &block if block_given?
    end

    def rule(name, &block)
      @root ||= name
      @rules[name] = Parser.new { |input| block.call.run(input) } if block_given?
      @rules[name]
    end

    def start(name)
      @root = name
    end

    def run(input)
      rule(root).run(input)
    end
  end
end