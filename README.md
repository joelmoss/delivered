# Delivered: Simple runtime type checking for Ruby method signatures

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
the required `Integer`, a `NoMatchingPatternError` exception will be raised.

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
