# Delivered: Simple runtime type checking for Ruby method signatures

> Signed, Sealed, Delivered 🎹

Delivered gives you the ability to define method signatures in Ruby, and have them checked at
runtime. This is useful for ensuring that your methods are being called with the correct arguments,
and for providing better error messages when they are not. It also serves as a nice way of
documenting your methods using actual code instead of comments.

## Usage

Simply define a method signature using the `sig` method directly before the method to be checked,
and Delivered will check that the method is being called with the correct arguments and types.

```ruby
class User
  extend Delivered::Signature

  sig String, age: Integer
  def create(name, age:)
    "User #{name} created with age #{age}"
  end
end
```

If an invalid argument is given to `User#create`, for example, if `age` is a `String` instead of
the required `Integer`, a `Delivered::ArgumentError` exception will be raised.

### Return Types

You can also check the return value of the method by passing a Hash with an Array as the key, and
the value as the return type to check.

```ruby
sig [String, age: Integer] => String
def create(name, age:)
  "User #{name} created with age #{age}"
end
```

Or by placing the return type in a block to `sig`.

```ruby
sig(String, age: Integer) { String }
def create(name, age:)
  "User #{name} created with age #{age}"
end
```

### Delivered Types

As well as Ruby's native types (ie. `String`, `Integer`, etc.), _Delivered_ provides a couple of
extra types in `Delivered::Types`.

You can call these directly with `Delivered::Types.Boolean`, or for brevity, assign
`Delivered::Types` to `T` in your classes:

```ruby
class User
  extend Delivered::Signature
  T = Delivered::Types
end
```

The following examples all use the `T` alias, and assumes the above.

#### `Boolean`

Value **MUST** be `true` or `false`. Does not support "truthy" or "falsy" values.

```ruby
sig validate: T.Boolean
def create(validate:); end
```

#### `Any`

Value **MUST** be any of the given list of values, that is, the value must be one of the given list.

```ruby
sig T.Any(:male, :female)
def create(gender); end
```

If no type is given, the value **CAN** be any type or value.

```ruby
sig save: T.Any
def create(save: nil); end
```

You can also pass `nil` to allow a nil value alongside any other types you provide.

```ruby
sig T.Any(String, nil)
def create(save = nil); end
```

#### `Nilable`

When a type is given, the value **MUST** be nil **OR** of the given type.

```ruby
sig save: T.Nilable(String)
def create(save: nil); end

sig T.Nilable(String)
def update(name = nil); end
```

If no type is given, the value **CAN** be nil. This essentially allows any value, including nil.

```ruby
sig save: T.Nilable
def create(save: nil); end
```

You may notice that `Nilable` is interchangeable with `Any`. The following are equivilent:

```ruby
sig save: T.Nilable
def create(save: nil); end
```

```ruby
sig save: T.Any
def create(save: nil); end
```

As are these:

```ruby
sig T.Nilable(String)
def update(name = nil); end
```

```ruby
sig T.Any(String, nil)
def update(name = nil); end
```
