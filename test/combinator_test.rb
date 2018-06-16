require "test_helper"

module Parseus
  class CombinatorTest < Minitest::Test
    describe 'many' do
      let(:parser) { Parser.digit.many }

      it 'parses on no match' do
        parses_successfully '', [], ''
      end

      it 'parses on match' do
        parses_successfully '1234abc', ['1', '2', '3', '4'], 'abc'
      end
    end

    describe 'some' do
      let(:parser) { Parser.digit.some }

      it 'parses on match' do
        parses_successfully '123a', ['1', '2', '3'], 'a'
      end

      it 'does not parse on empty input' do
        fails_to_parse ''
      end
    end

    describe 'discard_*' do
      let(:parser) { Parser.one_of(' ').many.discard_left(Parser.number).discard_right(Parser.one_of(' ').many) }

      it 'parses a number surrounded by whitespace' do
        parses_successfully '     15  ', 15, ''
      end
    end

    describe 'and_then' do
      let(:parser) { Parser.letter.and_then Parser.digit }

      it 'parses a letter followed by a digit' do
        parses_successfully 'a1', ['a', '1'], ''
      end
    end

    describe 'or' do
      let(:parser) { Parser.letter.or Parser.digit }

      it 'parses first option' do
        parses_successfully 'abc', 'a', 'bc'
      end

      it 'parses the second option' do
        parses_successfully '1bc', '1', 'bc'
      end
    end

    describe 'sequence' do
      let(:parser) { Parser.sequence(Parser.letter, Parser.letter, Parser.letter) }

      it 'parses three characters' do
        parses_successfully 'abc', ['a', 'b', 'c'], ''
      end
    end

    describe 'options' do
      let(:parser) do
        Parser.options(Parser.satisfy { |r| r == 'a' },
                       Parser.satisfy { |r| r == 'b' },
                       Parser.satisfy { |r| r == 'c' })
      end

      it 'parses on of the options' do
        parses_successfully 'a', 'a', ''
        parses_successfully 'b', 'b', ''
        parses_successfully 'c', 'c', ''
        fails_to_parse 'd'
      end
    end
  end
end
