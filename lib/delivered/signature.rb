# frozen_string_literal: true

module Delivered
  module Signature
    NULL = Object.new

    def sig(*sig_args, returns: NULL, **sig_kwargs)
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

          result = if block
                     send(:"__#{name}", *args, **kwargs, &block)
                   else
                     send(:"__#{name}", *args, **kwargs)
                   end

          result => ^returns if returns != NULL

          result
        end
      end
    end
  end
end
