# frozen_string_literal: true

module Delivered
  class AnyType
    def initialize(*types)
      @types = types
    end

    def ===(value)
      @types.empty? ? true : @types.any? { |type| type === value }
    end
  end

  class NilableType
    def initialize(type = nil)
      @type = type
    end

    def ===(value)
      (@type.nil? ? true : nil === value) || @type === value
    end
  end

  class BooleanType
    def initialize
      freeze
    end

    def ===(value)
      [true, false].include?(value)
    end
  end

  module Types
    module_function

    def Nilable(type = nil) = NilableType.new(type)
    def Any(*types) = AnyType.new(*types)
    def Boolean = BooleanType.new
  end
end
