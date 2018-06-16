module Parseus
  class Parser
    module Combinator
      def many(parser)
        Parser.new do |input|
          result = nil
          matched = []
          loop do
            result = parser.run(input)
            if result.success?
              matched << result.result
              input = result.remaining
            else
              result = ParseResult.success(matched, input)
              break
            end
          end
          result
        end
      end

      def some(parser)
        Parser.new(parser.failure_message) do |input|
          result = many(parser).run(input)
          if result.result.empty?
            ParseResult.failure('Could not match some', result.remaining)
          else
            result
          end
        end
      end

      def discard_left(left, right)
        Parser.new do |input|
          left.run(input).on_success do |result|
            right.run(result.remaining)
          end
        end
      end

      def discard_right(left, right)
        Parser.new do |input|
          left.run(input).on_success do |result|
            right.run(result.remaining).on_success do |right_result|
              ParseResult.success(result.result, right_result.remaining)
            end
          end
        end
      end

      def and_then(left, right)
        Parser.new do |input|
          left.run(input).on_success do |result|
            right.run(result.remaining).on_success do |right_result|
              partial = Array(result.result)
              ParseResult.success(partial << right_result.result,
                                  right_result.remaining)
            end
          end
        end
      end

      def or(left, right)
        Parser.new do |input|
          left.run(input).on_failure do
            right.run(input)
          end
        end
      end

      def exactly(parser, count)
        Parser.new do |input|
          matched = []
          count.times do
            result = parser.run(input)
            return result if result.failure?
            matched << result.result
            input = result.remaining
          end
          ParseResult.success(matched, input)
        end
      end
    end
  end
end
