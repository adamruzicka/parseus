require 'test_helper'

module Parseus
  class ParserTest < Minitest::Test
    # rubocop:disable Metrics/BlockLength
    describe Parser do
      describe 'unit' do
        let(:unit) { 'something' }
        let(:parser) { Parser.unit unit }

        it 'does not consume input' do
          input = 'whatever'
          parses_successfully input, unit, input
        end
      end

      describe 'item' do
        let(:parser) { Parser.item }

        it 'consumes single element from input' do
          parses_successfully 'abc', 'a', 'bc'
        end

        it 'fails on empty input' do
          fails_to_parse ''
        end
      end

      describe 'satisfy' do
        let(:parser) { Parser.satisfy { |x| ('a'..'c').cover? x } }

        it 'consumes single element from input if condition is met' do
          parses_successfully 'cb', 'c', 'b'
        end
      end

      describe 'letter' do
        let(:parser) { Parser.letter }

        it 'consumes single character' do
          parses_successfully 'abc', 'a', 'bc'
        end

        it 'fails on wrong input' do
          fails_to_parse ''
          fails_to_parse '123'
          fails_to_parse ' a'
        end
      end

      describe 'digit' do
        let(:parser) { Parser.digit }

        it 'consumes single digit' do
          parses_successfully '1a2', '1', 'a2'
        end

        it 'fails on wrong input' do
          fails_to_parse ''
          fails_to_parse 'abc'
        end
      end

      describe 'map' do
        let(:inner) { Parser.digit }
        let(:parser) { inner.map(&:to_i) }

        it 'maps result of another parser' do
          parses_successfully '12', 1, '2'
        end
      end
    end

    describe 'number' do
      let(:parser) { Parser.number }

      it 'parses a number' do
        parses_successfully '1234abc', 1234, 'abc'
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
