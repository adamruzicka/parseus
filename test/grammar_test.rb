require 'test_helper'

module Parseus
  class GrammarTest < Minitest::Test
    describe Grammar do
      let(:parser) { grammar.root_rule }

      describe 'UUID parsing' do
        let(:grammar) do
          Grammar.new do
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
              letters = [('a'..'f'), ('A'..'F')]
              digit | satisfy { |c| letters.any? { |group| group.cover? c } }
            end
          end
        end

        it 'can be used to parse UUIDs' do
          uuid = 'e1f3ea83-6e14-400d-bb3c-0b5284bd3f2c'
          parses_successfully uuid, uuid, ''
        end
      end

      describe 'simple arithmetic' do
        let(:grammar) do
          Grammar.new do
            rule(:root) { rule(:expression) > eof }
            rule(:lparen) { symbol('(').map(&:to_sym) }
            rule(:rparen) { symbol(')').map(&:to_sym) }
            rule(:wrapped) { sequence(rule(:lparen), rule(:expression), rule(:rparen)) }
            rule(:expression) { rule(:wrapped) | sequence((rule(:wrapped) | rule(:number)), rule(:operator), rule(:expression)) | rule(:number) }
            rule(:operator) { one_of('+', '-') }
            rule(:number) { number }
          end
        end

        it 'can parse a single number' do
          parses_successfully '1', 1
        end

        it 'can parse a simple expression' do
          parses_successfully '1+2', [1, '+', 2]
        end

        it 'can parse a single number in parentheses' do
          parses_successfully '(1)', [:"(", 1, :")"]
        end

        it 'can parse a simple expression in parentheses' do
          parses_successfully '(1+2)', [:"(", [1, '+', 2], :")"]
        end

        it 'can parse a more complicated expressions' do
          parses_successfully '1+2+3', [1, '+', [2, '+', 3]]
          parses_successfully '1+(2+3)', [1, '+', [:"(", [2, '+', 3], :")"]]
          parses_successfully '(1+2)+3', [1, '+', [:"(", [2, '+', 3], :")"]]
        end
      end
    end
  end
end
