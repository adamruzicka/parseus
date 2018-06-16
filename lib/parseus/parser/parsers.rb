module Parseus
  class Parser
    module Parsers
      def unit(thing)
        Parser.new do |input|
          ParseResult.success(thing, input)
        end
      end

      def item
        Parser.new do |input|
          if input.empty?
            ParseResult.failure('No more input', input)
          else
            ParseResult.success(input[0], input[1..-1])
          end
        end
      end

      def satisfy
        Parser.new do |input, parser|
          item.run(input).on_success do |result|
            if yield result.result
              result
            else
              msg = parser.failure_message || "'#{result.result}' does not satisfy the condition"
              ParseResult.failure(msg, result.remaining)
            end
          end
        end
      end

      def letter
        satisfy { |char| [('a'..'z'), ('A'..'Z')].any? { |range| range.include? char } }
      end

      def symbol(symbol)
        satisfy { |char| char == symbol }
      end

      def digit
        satisfy { |char| ('0'..'9').include? char }
      end

      def one_of(*options)
        options = options.first.split('') if options.count == 1 && options.is_a?(String)
        satisfy { |char| options.include? char }
      end

      def map(other, &block)
        Parser.new do |input|
          other.run(input).on_success do |result|
            result.map &block
          end
        end
      end

      def number
        digit.some.map { |result| result.join('').to_i }
      end

      def options(*parsers)
        parsers.reduce { |acc, cur| acc.or cur }
      end

      def sequence(*parsers)
        parsers.reduce { |acc, cur| acc.and_then cur }
      end

      def eof
        Parser.new do |input|
          if input.empty?
            ParseResult.success(nil, input)
          else
            ParseResult.failure('Not EOF yet', input)
          end
        end
      end

      def string(str)
        Parser.new do |input|
          if input.start_with? str
            ParseResult.success(str, input[str.length..-1])
          else
            ParseResult.failure("'#{str}' expected, found '#{input[0..str.length - 1]}'", input)
          end
        end
      end
    end
  end
end