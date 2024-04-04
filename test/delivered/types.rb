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
      it 'one of given arg' do
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
