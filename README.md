# Delivered: Simple runtime type checking for Ruby method signatures

Delivered gives you the ability to define method signatures in Ruby, and have them checked at
runtime. This is useful for ensuring that your methods are being called with the correct arguments,
and for providing better error messages when they are not.

Simply define a method signature using the `sig` method directly before the method to be checked,
and Delivered will check that the method is being called with the correct arguments and types. it
can alos chreck the return value of the method.

```ruby
class User
  extend Delivered::Signature

  sig String, age: Integer, returns: String
  def create(name, age:)
    "User #{name} created with age #{age}"
  end
end
```
