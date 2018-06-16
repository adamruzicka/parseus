require 'test_helper'

module Parseus
  class GrammarTest < Minitest::Test
    describe Grammar do
      it 'can be used to parse UUIDs' do
        g = Grammar.new do
          rule(:uuid) do
            rules = (rule :hexadecimal).exactly(8),
                    (symbol '-'),
                    (rule :hexadecimal).exactly(4),
                    (symbol '-'),
                    (rule :hexadecimal).exactly(4),
                    (symbol '-'),
                    (rule :hexadecimal).exactly(4),
                    (symbol '-'),
                    (rule :hexadecimal).exactly(12)
            sequence(*rules).map { |parts| parts.flatten.join }
          end

          rule(:hexadecimal) do
            digit | satisfy { |c| [('a'..'z'), ('A'..'Z')].any? { |group| group.include? c } }
          end
        end
        uuid = 'e1f3ea83-6e14-400d-bb3c-0b5284bd3f2c'
        result = g.run('e1f3ea83-6e14-400d-bb3c-0b5284bd3f2c')
        result.must_be(:success?)
        result.remaining.must_equal ''
        result.result.must_equal uuid
      end
    end
  end
end

