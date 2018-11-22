module Parseus
  class Grammar
    include Parser::Parsers
    include Parser::Combinator

    attr_reader :root
    def initialize(auto_tokenize: false, &block)
      @rules = {}
      @root = nil
      @auto_tokenize = auto_tokenize
      instance_eval(&block) if block_given?
    end

    def rule(name)
      @root ||= name
      @rules[name] = Parser.new { |input| yield.run(input) } if block_given?
      @rules[name]
    end

    def root_rule
      rule(root)
    end

    def start(name)
      @root = name
    end

    def run(input)
      root_rule.run(input)
    end
  end
end
