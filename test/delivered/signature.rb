# frozen_string_literal: true

describe Delivered::Signature do
  class User
    extend Delivered::Signature

    attr_reader :town, :blk

    sig String, Integer, town: String
    def initialize(name, age = nil, town: nil, &block)
      @name = name
      @age = age
      @town = town
      @blk = block
    end

    sig returns: String
    def to_s = "#{@name}, #{@age}"

    sig returns: Integer
    def age = @age.to_s

    sig Integer, returns: Integer
    attr_writer :age
  end

  it 'supports positional args' do
    user = User.new('Joel', 47)
    expect(user.to_s).to be == 'Joel, 47'
  end

  # it 'supports optional positional args'

  it 'supports block' do
    user = User.new('Joel', 47) { 'Hello' }
    expect(user.blk.call).to be == 'Hello'
  end

  it 'checks return type' do
    user = User.new('Joel', 47)
    expect(user.to_s).to be == 'Joel, 47'
  end

  it 'raises on incorrect return type' do
    user = User.new('Joel', 47)
    expect { user.age }.to raise_exception NoMatchingPatternError
  end

  it 'checks return type with args' do
    user = User.new('Joel', 47)
    expect(user.age = 48).to be == 48
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
