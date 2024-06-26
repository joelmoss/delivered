# frozen_string_literal: true

describe Delivered::Signature do
  class User
    extend Delivered::Signature

    attr_reader :town, :blk

    sig(Integer) { Integer }
    attr_writer :age

    sig String, town: String
    def initialize(name, age = nil, town: nil, &block)
      @name = name
      @age = age
      @town = town
      @blk = block
    end

    sig(String, age: Integer) { Integer }
    def with_block_return(name, age:) = 1 # rubocop:disable Lint/UnusedMethodArgument

    sig(String, age: Integer) { Integer }
    def with_incorrect_block_return = 'hello'

    sig [String, age: Integer] => Integer
    def with_incorrect_hash_return = 'hello'

    sig [String, age: Integer] => Integer
    def with_hash_return(name, age:) = 1 # rubocop:disable Lint/UnusedMethodArgument

    sig [] => String
    def to_s = "#{@name}, #{@age}"

    sig { Integer }
    def age = @age.to_s

    sig(Delivered::Types.Boolean)
    def active=(val); end

    sig(String, _age: Integer) { Array }
    def self.where(_name, _age: nil) = []

    sig [String] => Array
    def self.find_by_name(name) = User.new(name)
  end

  with 'return type with hash' do
    it 'succeeds' do
      user = User.new('Joel')
      expect(user.with_hash_return('Joel', age: 47)).to be == 1
    end

    it 'raises on incorrect types' do
      user = User.new('Joel')
      expect { user.with_hash_return }.to raise_exception Delivered::ArgumentError
    end

    it 'raises on incorrect return type' do
      user = User.new('Joel')
      expect { user.with_incorrect_hash_return }.to raise_exception Delivered::ArgumentError
    end
  end

  with 'return type as block' do
    it 'succeeds' do
      user = User.new('Joel')
      expect(user.with_block_return('Joel', age: 47)).to be == 1
    end

    it 'raises on incorrect types' do
      user = User.new('Joel')
      expect { user.with_block_return }.to raise_exception Delivered::ArgumentError
    end

    it 'raises on incorrect return type' do
      user = User.new('Joel')
      expect { user.with_incorrect_block_return }.to raise_exception Delivered::ArgumentError
    end
  end

  it 'raises on mix of returns' do
    extend Delivered::Signature

    expect do
      sig([] => Integer) { Integer }
    end.to raise_exception(ArgumentError, message: be =~ /Cannot mix/)
  end

  it 'supports positional args' do
    user = User.new('Joel', 47)
    expect(user.to_s).to be == 'Joel, 47'
  end

  with 'rest args' do
    it 'no args given' do
      class Name
        extend Delivered::Signature

        sig String
        def rest(name, *attributes)
          [name, attributes]
        end
      end

      expect(Name.new.rest('Joel')).to be == ['Joel', []]
    end

    it 'args given' do
      class Name
        extend Delivered::Signature

        sig String
        def rest(name, *attributes)
          [name, attributes]
        end
      end

      expect(Name.new.rest('Joel', :foo)).to be == ['Joel', [:foo]]
    end

    it 'sig args defined' do
      class Name
        extend Delivered::Signature

        sig String, String
        def rest(name, last_name, *attributes)
          [name, last_name, attributes]
        end
      end

      expect(Name.new.rest('Joel', 'Moss', :foo)).to be == ['Joel', 'Moss', [:foo]]
    end
  end

  with 'rest kwargs' do
    it 'no kwargs given' do
      class Name
        extend Delivered::Signature

        sig String
        def rest(name, **attributes)
          [name, attributes]
        end
      end

      expect(Name.new.rest('Joel')).to be == ['Joel', {}]
    end

    it 'kwargs given' do
      class Name
        extend Delivered::Signature

        sig String
        def rest(name, **attributes)
          [name, attributes]
        end
      end

      expect(Name.new.rest('Joel', foo: :bar)).to be == ['Joel', { foo: :bar }]
    end
  end

  with 'named and rest kwargs' do
    it 'named kwarg given' do
      class Name
        extend Delivered::Signature

        sig String
        def rest(name, age:, **attributes)
          [name, age:, **attributes]
        end
      end

      expect(Name.new.rest('Joel', age: 47)).to be == ['Joel', { age: 47 }]
    end

    it 'named and rest kwarg given' do
      class Name
        extend Delivered::Signature

        sig String
        def rest(name, age:, **attributes)
          [name, age:, **attributes]
        end
      end

      expect(Name.new.rest('Joel', age: 47, town: 'Chorley'))
        .to be == ['Joel', { age: 47, town: 'Chorley' }]
    end
  end

  with 'rest args and kwargs' do
    it 'no args given' do
      class Name
        extend Delivered::Signature

        sig String
        def rest(name, *args, **kwargs)
          [name, args, kwargs]
        end
      end

      expect(Name.new.rest('Joel')).to be == ['Joel', [], {}]
    end

    it 'args given' do
      class Name
        extend Delivered::Signature

        sig String
        def rest(name, *args, **kwargs)
          [name, args, kwargs]
        end
      end

      expect(Name.new.rest('Joel', :foo, bar: :foo)).to be == ['Joel', [:foo], { bar: :foo }]
    end
  end

  it 'supports block' do
    user = User.new('Joel', 47) { 'Hello' }
    expect(user.blk.call).to be == 'Hello'
  end

  with 'attr_writer' do
    it 'succeeds' do
      user = User.new('Joel')
      expect(user.age = 47).to be == 47
    end

    it 'raise on incorrect type' do
      user = User.new('Joel', 47)
      expect { user.age = '47' }.to raise_exception Delivered::ArgumentError
    end
  end

  it 'raises on incorrect Delivered type' do
    user = User.new('Joel')
    expect { user.active = 1 }.to raise_exception Delivered::ArgumentError
  end

  it 'raises on missing args' do
    expect { User.new }.to raise_exception Delivered::ArgumentError
  end

  it 'raises on incorrect arg type' do
    expect { User.new 1 }.to raise_exception Delivered::ArgumentError
  end

  it 'supports keyword args' do
    expect(User.new('Joel', 47, town: 'Chorley').town).to be == 'Chorley'
  end

  it 'raises on incorrect kwarg type' do
    expect { User.new('Joel', town: 1) }.to raise_exception Delivered::ArgumentError
  end

  with 'class methods' do
    it 'supports class method signatures' do
      expect(User.where('Joel')).to be == []
    end

    it 'raises on incorrect return type' do
      expect { User.find_by_name('Hugo') }.to raise_exception Delivered::ArgumentError
    end

    it 'raises on missing args' do
      expect { User.where }.to raise_exception Delivered::ArgumentError
    end

    it 'raises on incorrect arg type' do
      expect { User.where(1) }.to raise_exception Delivered::ArgumentError
    end

    it 'supports keyword args' do
      expect(User.where('hugo', _age: 27)).to be == []
    end

    it 'raises on incorrect kwarg type' do
      expect { User.where(1, _age: 'twentyseven') }.to raise_exception Delivered::ArgumentError
    end
  end
end
