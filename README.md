# Delivered: Simple runtime type checking for Ruby method signatures

Delivered gives you the ability to define method signatures in Ruby, and have them checked at
runtime. This is useful for ensuring that your methods are being called with the correct arguments,
and for providing better error messages when they are not. It also serves as a nice way of
documenting your methods using actual code instead of comments.

Simply define a method signature using the `sig` method directly before the method to be checked,
and Delivered will check that the method is being called with the correct arguments and types. it
can also check the return value of the method if you pass `sig` a `returns` keyword argument.

```ruby
class User
  extend Delivered::Signature

  sig String, age: Integer, returns: String
  def create(name, age:)
    "User #{name} created with age #{age}"
  end
end
```

If an invalid argument is given to `User#create`, for example, if `age` is a `String` instead of
the required `Integer`, a `NoMatchingPatternError` exception will be raised.
