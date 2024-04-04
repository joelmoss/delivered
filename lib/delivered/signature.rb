# frozen_string_literal: true

module Delivered
  module Signature
    NULL = Object.new

    def sig(*sig_args, **sig_kwargs, &return_blk)
      # ap [sig_args, sig_kwargs, return_blk]

      # Block return
      returns = return_blk&.call

      # Hashrocket return
      if sig_kwargs.keys[0].is_a?(Array)
        unless returns.nil?
          raise ArgumentError, 'Cannot mix block and hash for return type. Use one or the other.'
        end

        returns = sig_kwargs.values[0]
        sig_args = sig_kwargs.keys[0]
        sig_kwargs = sig_args.pop
      end

      # ap sig_args
      # ap sig_kwargs
      # ap returns

      meta = class << self; self; end
      sig_check = lambda do |klass, name, *args, **kwargs, &block|
        sig_args.each.with_index do |arg, i|
          args[i] => ^arg
        end

        kwargs.each do |key, value|
          value => ^(sig_kwargs[key])
        end

        result = if block
                   klass.send(:"__#{name}", *args, **kwargs, &block)
                 else
                   klass.send(:"__#{name}", *args, **kwargs)
                 end

        result => ^returns unless returns.nil?

        result
      end

      meta.send :define_method, :method_added do |name|
        meta.send :remove_method, :method_added
        meta.send :remove_method, :singleton_method_added

        alias_method :"__#{name}", name
        define_method name do |*args, **kwargs, &block|
          sig_check.call(self, name, *args, **kwargs, &block)
        end
      end

      meta.send :define_method, :singleton_method_added do |name|
        next if name == :singleton_method_added

        meta.send :remove_method, :singleton_method_added
        meta.send :remove_method, :method_added

        meta.alias_method :"__#{name}", name
        define_singleton_method name do |*args, **kwargs, &block|
          sig_check.call(self, name, *args, **kwargs, &block)
        end
      end
    end
  end
end
