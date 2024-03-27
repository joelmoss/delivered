# frozen_string_literal: true

module Delivered
  module Signature
    def sig(*sig_args, returns: nil, **sig_kwargs) # rubocop:disable Lint/UnusedMethodArgument
      meta = class << self; self; end
      meta.send :define_method, :method_added do |name|
        meta.send :remove_method, :method_added

        alias_method :"__#{name}", name
        define_method name do |*args, **kwargs, &block|
          sig_args.each.with_index do |arg, i|
            args[i] => ^arg
          end

          kwargs.each do |key, value|
            value => ^(sig_kwargs[key])
          end

          if block
            send(:"__#{name}", *args, **kwargs, &block).tap { |x| x => returns }
          else
            send(:"__#{name}", *args, **kwargs).tap { |x| x => returns }
          end
        end
      end
    end
  end
end
