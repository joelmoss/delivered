# frozen_string_literal: true

describe Delivered::Types do
  T = Delivered::Types

  describe 'Any' do
    with 'no arguments' do
      it 'any type or nil' do
        assert T.Any === :one
        assert T.Any === 'one'
        assert T.Any === nil
      end
    end

    with 'arguments' do
      it 'is one of given arg' do
        assert T.Any(:one, :two) === :one
        assert T.Any(String, Integer) === 'one'
        assert T.Any(String, Integer) === 1
        assert T.Any(Integer, nil) === nil
      end
    end

    it 'raises when value is not valid' do
      expect { :three => ^(T.Any(:one, :two)) }.to raise_exception NoMatchingPatternError
      expect { :one => ^(T.Any(:one, :two)) }.not.to raise_exception
      expect { 'one' => ^(T.Any(Symbol, String)) }.not.to raise_exception
      expect { 'one' => ^(T.Any) }.not.to raise_exception
      expect { nil => ^(T.Any) }.not.to raise_exception
      expect { nil => ^(T.Any(String, nil)) }.not.to raise_exception
      expect { true => ^(T.Any(String, nil)) }.to raise_exception NoMatchingPatternError
    end
  end

  describe 'RespondTo' do
    it 'should respond to given method' do
      assert T.RespondTo(:to_s) === 'foo'
      assert T.RespondTo(:to_s, :to_i) === 'foo'
    end

    it 'raises when not respond to' do
      expect { :foo => ^(T.RespondTo(:bar)) }.to raise_exception NoMatchingPatternError
    end
  end

  describe 'ArrayOf' do
    it 'should be an Array of given type' do
      assert T.ArrayOf(Integer) === [1, 2]
      assert T.ArrayOf(Integer) === []
    end

    it 'raises when not an Array' do
      expect { 1 => ^(T.ArrayOf(Integer)) }.to raise_exception NoMatchingPatternError
    end

    it 'raises when not an Array of given type' do
      expect { [1] => ^(T.ArrayOf(String)) }.to raise_exception NoMatchingPatternError
      expect { ['w', 1] => ^(T.ArrayOf(String)) }.to raise_exception NoMatchingPatternError
    end
  end

  describe 'Enumerable' do
    it 'should be an Enumerable of given type' do
      assert T.Enumerable === []
      assert T.Enumerable(Integer) === [1, 2]
      assert T.Enumerable(Integer) === []
    end

    it 'raises when not an Enumerable' do
      expect { 1 => ^(T.Enumerable(Integer)) }.to raise_exception NoMatchingPatternError
    end

    it 'raises when not an Enumerable of given type' do
      expect { [1] => ^(T.Enumerable(String)) }.to raise_exception NoMatchingPatternError
      expect { ['w', 1] => ^(T.Enumerable(String)) }.to raise_exception NoMatchingPatternError
    end
  end

  describe 'RangeOf' do
    it 'should be a Range of given type' do
      assert T.RangeOf(Integer) === (1..2)
      assert T.RangeOf(Integer) === (..2)
      assert T.RangeOf(Integer) === (1..)
    end

    it 'raises when not a Range' do
      expect { 1 => ^(T.RangeOf(Integer)) }.to raise_exception NoMatchingPatternError
    end

    it 'raises when not a Range of given type' do
      expect { 1..2 => ^(T.RangeOf(String)) }.to raise_exception NoMatchingPatternError
      expect { 1.. => ^(T.RangeOf(String)) }.to raise_exception NoMatchingPatternError
      expect { ..2 => ^(T.RangeOf(String)) }.to raise_exception NoMatchingPatternError
    end
  end

  describe 'Boolean' do
    it 'should be true or false' do
      assert T.Boolean === true
      assert T.Boolean === false
    end

    it 'raises when not boolean' do
      expect { 0 => ^(T.Boolean) }.to raise_exception NoMatchingPatternError
    end
  end

  describe 'Nilable' do
    it 'can be nil' do
      assert T.Nilable === nil
    end

    with 'no given type' do
      it 'can be any type' do
        assert T.Nilable === 'hello'
        expect { 'hello' => ^(T.Nilable) }.not.to raise_exception NoMatchingPatternError
      end
    end

    it 'can receive another type' do
      assert T.Nilable(String) === 'hello'
      assert T.Nilable(String) === nil
      expect { 'hello' => ^(T.Nilable(String)) }.not.to raise_exception
      expect { 1 => ^(T.Nilable(String)) }.to raise_exception NoMatchingPatternError
    end
  end
end
