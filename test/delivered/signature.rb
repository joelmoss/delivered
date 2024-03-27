# frozen_string_literal: true

describe Delivered::Signature do
  class User
    extend Delivered::Signature

    attr_reader :town, :blk

    sig String, Integer, town: String, returns: User
    def initialize(name, age = nil, town: nil, &block)
      @name = name
      @age = age
      @town = town
      @blk = block
    end

    sig returns: String
    def to_s = "#{@name}, #{@age}"
  end

  it 'supports positional args' do
    expect(User.new('Joel', 47).to_s).to be == 'Joel, 47'
  end

  it 'supports block' do
    user = User.new('Joel', 47) { 'Hello' }
    expect(user.blk.call).to be == 'Hello'
  end

  it 'raises on missing args' do
    expect { User.new }.to raise_exception NoMatchingPatternError
  end

  it 'raises on incorrect arg type' do
    expect { User.new 1 }.to raise_exception NoMatchingPatternError
  end

  it 'supports keyword args' do
    expect(User.new('Joel', 47, town: 'Chorley').town).to be == 'Chorley'
  end

  it 'raises on incorrect kwarg type' do
    expect { User.new('Joel', town: 1) }.to raise_exception NoMatchingPatternError
  end
end
