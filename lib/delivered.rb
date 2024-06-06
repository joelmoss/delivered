# frozen_string_literal: true

module Delivered
  EXPENSIVE_TYPE_CHECKS = ENV['DELIVERED_EXPENSIVE_TYPE_CHECKS'] != 'false'

  class ArgumentError < ArgumentError
  end

  autoload :Signature, 'delivered/signature'
  autoload :Types, 'delivered/types'
end
