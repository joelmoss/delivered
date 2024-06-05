# frozen_string_literal: true

module Delivered
  class AnyType
    def initialize(*types)
      @types = types
    end

    def inspect = "Any(#{@types.map(&:inspect).join(', ')})"

    def ===(value)
      @types.empty? ? true : @types.any? { |type| type === value }
    end
  end

  class RangeOfType
    def initialize(type)
      @type = type
    end

    def inspect = "Range(#{@type&.inspect})"

    def ===(value)
      Range === value && (
        (@type === value.begin && (nil === value.end || @type === value.end)) ||
        (@type === value.end && nil === value.begin)
      )
    end
  end

  class RespondToType
    def initialize(*methods)
      @methods = methods
    end

    def inspect = "RespondTo(#{@methods.map(&:inspect).join(', ')})"

    def ===(value)
      @methods.all? { |m| value.respond_to?(m) }
    end
  end

  class NilableType
    def initialize(type = nil)
      @type = type
    end

    def inspect = "Nilable(#{@type&.inspect || 'Any'})"

    def ===(value)
      (@type.nil? ? true : nil === value) || @type === value
    end
  end

  class BooleanType
    def initialize
      freeze
    end

    def inspect = 'Boolean'

    def ===(value)
      [true, false].include?(value)
    end
  end

  module Types
    module_function

    def Nilable(type = nil) = NilableType.new(type)
    def RangeOf(type = nil) = RangeOfType.new(type)
    def RespondTo(*methods) = RespondToType.new(*methods)
    def Any(*types) = AnyType.new(*types)
    def Boolean = BooleanType.new
  end
end
