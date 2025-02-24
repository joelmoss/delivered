# frozen_string_literal: true

module Delivered
  EXPENSIVE_TYPE_CHECKS = ENV['DELIVERED_EXPENSIVE_TYPE_CHECKS'] != 'false'

  class ArgumentError < ArgumentError; end
  class VerifyError < StandardError; end

  autoload :Signature, 'delivered/signature'
  autoload :Types, 'delivered/types'

  module_function

  def verify!(value, type)
    value => ^type
  rescue NoMatchingPatternError => e
    raise Delivered::VerifyError, "Expected `#{value.inspect}` to be #{type.inspect}", cause: e
  end
end
