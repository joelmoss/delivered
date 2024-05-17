# frozen_string_literal: true

module Delivered
  module Signature
    def sig(*sig_args, **sig_kwargs, &return_blk)
      # ap [sig_args, sig_kwargs, return_blk]

      # Block return
      returns = return_blk&.call

      # Hashrocket return
      if sig_kwargs.keys[0].is_a?(Array)
        unless returns.nil?
          raise Delivered::ArgumentError,
                'Cannot mix block and hash for return type. Use one or the other.', caller
        end

        returns = sig_kwargs.values[0]
        sig_args = sig_kwargs.keys[0]
        sig_kwargs = sig_args.pop if sig_args.last.is_a?(Hash)
      end

      # ap [sig_args, sig_kwargs, returns]

      meta = class << self; self; end
      sig_check = lambda do |klass, class_method, name, *args, **kwargs, &block| # rubocop:disable Metrics/BlockLength
        cname = if class_method
                  "#{klass.name}.#{name}"
                else
                  "#{klass.class.name}##{name}"
                end

        sig_args.each.with_index do |arg, i|
          args[i] => ^arg
        rescue NoMatchingPatternError => e
          raise Delivered::ArgumentError,
                "`#{cname}` expected #{arg.inspect} as argument #{i}, but received " \
                "`#{args[i].inspect}`",
                caller, cause: e
        end

        kwargs.each do |key, value|
          value => ^(sig_kwargs[key])
        rescue NoMatchingPatternError => e
          raise Delivered::ArgumentError,
                "`#{cname}` expected #{sig_kwargs[key].inspect} as keyword argument :#{key}, " \
                "but received `#{value.inspect}`",
                caller, cause: e
        end

        result = if block
                   klass.send(:"__#{name}", *args, **kwargs, &block)
                 else
                   klass.send(:"__#{name}", *args, **kwargs)
                 end

        begin
          result => ^returns unless returns.nil?
        rescue NoMatchingPatternError => e
          raise Delivered::ArgumentError,
                "`#{cname}` expected to return #{returns.inspect}, " \
                "but returned `#{result.inspect}`",
                caller, cause: e
        end

        result
      end

      meta.send :define_method, :method_added do |name|
        meta.send :remove_method, :method_added
        meta.send :remove_method, :singleton_method_added

        alias_method :"__#{name}", name
        define_method name do |*args, **kwargs, &block|
          sig_check.call(self, false, name, *args, **kwargs, &block)
        end
      end

      meta.send :define_method, :singleton_method_added do |name|
        next if name == :singleton_method_added

        meta.send :remove_method, :singleton_method_added
        meta.send :remove_method, :method_added

        meta.alias_method :"__#{name}", name
        define_singleton_method name do |*args, **kwargs, &block|
          sig_check.call(self, true, name, *args, **kwargs, &block)
        end
      end
    end
  end
end
