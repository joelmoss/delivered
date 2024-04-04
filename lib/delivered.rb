# frozen_string_literal: true

module Delivered
  class ArgumentError < ArgumentError
  end

  autoload :Signature, 'delivered/signature'
  autoload :Types, 'delivered/types'
end
