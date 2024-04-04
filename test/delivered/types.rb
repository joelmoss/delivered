# frozen_string_literal: true

describe Delivered::Types do
  T = Delivered::Types

  describe 'Union' do
    it 'is within union' do
      assert T.Union(:one, :two) === :one
    end

    it 'raises when value is not in union' do
      expect { :three => ^(T.Union(:one, :two)) }.to raise_exception NoMatchingPatternError
      expect { :one => ^(T.Union(:one, :two)) }.not.to raise_exception
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
