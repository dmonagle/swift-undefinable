# Undefinable

## Overview

The purpose of this type is represent the JSON undefined state in Swift structs and classes. 

The `Undefinable` `enum` is a generic with a `Wrapped` type, similar to `Optional`. The value is one of:

* .undefined
* .defined(Wrapped?)

When encoded with a `KeyedEncodingContainer`, an `.undefined` value will cause the entire key to be excluded from the encoded result.

When decoded with a `KeyedDecodingContainer`, an missing key will be decoded into an `.undefined` value.

`null` JSON values translate to `.defined(nil)` 

## Example

The best way to explain the user of `Undefined` is to demonstrate potential uses.

For example, consider the following simple struct:

```swift
struct User {
    var name: String
}
```

Now imagine in a framework like [Vapor](https://vapor.codes), you create a PATCH route which takes in a request like this:

```swift
struct UserUpdateRequest: Content {
    var name: String?
}
```

So it's easy to allow the PATCH request to optionally update the name by doing something like:

```swift
if let name = request.name {
    user.name = name
}
```

Now what happens when we want to add an optional age to our `User` struct?

```swift
struct User {
    var name: String
    var age: Int? // The user can optionally provide their age.
}
```

So adding an optional age to the `PATCH` request will not work as we won't know if it is `nil` because there was no change, or if it is `nil` because the user wants to explicitly set the age to `nil`. This is where we can use `Undefinable`. 

```swift
struct UserUpdateRequest: Content {
    var name: String?
    var age: Undefinable<Int>
}
```

Now in our controller, we can do this:

```swift
    request.age.unwrap {
        user.age = $0
    }
}
```

If there was no JSON key in the request for `age`, the value would be `.undefined` and the closure for `unwrap` would not be executed. However if the key existed and was set to either a value or null, the closure would execute and `$0` would be an `Optional<Int>`.

For convenience, there is also an `infix` operator to achieve the same thing:

```swift
    user.age ?= request.age
```

This will assign the unwrapped value to `user.age` as long as it was defined. 
