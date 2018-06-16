module Parseus
  class ParseResult
    class << self
      def success(result, remaining)
        Success.new(result, remaining)
      end

      def failure(error, remaining)
        Failure.new(error, remaining)
      end
    end

    class Abstract
      attr_reader :remaining

      def failure?
        !success?
      end

      def on_success
        success? ? yield self : self
      end

      def on_failure
        failure? ? yield self : self
      end

      def map
        @result = yield @result if success?
        self
      end
    end

    class Success < Abstract
      attr_reader :result

      def initialize(result, remaining)
        @result = result
        @remaining = remaining
      end

      def success?
        true
      end
    end

    class Failure < Abstract
      def initialize(error, remaining)
        @error = error
        @remaining = remaining
      end

      def success?
        false
      end
    end
  end
end
