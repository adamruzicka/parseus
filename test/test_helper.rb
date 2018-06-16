$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'parseus'

require 'minitest/autorun'
def parses_successfully(input, capture, remaining)
  result = parser.run(input)
  result.must_be(:success?)
  result.result.must_equal capture
  result.remaining.must_equal remaining
end

def fails_to_parse(input)
  result = parser.run(input)
  result.must_be(:failure?)
end
