# Canary Object Notation

## Introduction
The *Canary Object Notation* defines the text format to describe object.

## Copyright
Copyright (C) 2017 [Steel Wheels Project](http://steelwheels.github.io). This document distributed under
[GNU Free Documentation License](https://www.gnu.org/licenses/fdl-1.3.en.html).

## Download
- [Canary Framework](https://github.com/steelwheels/Canary): Source code repository which implements Canary Object Notation

## Syntax
### Basic rule
`identifier: type value`
- `identifier` : Name of the object.
- `type`: Data type of object. This is optional. When there are no type declaration, the type will be estimated by the value.
- `values` : Value of the object. There are 3 kind of object:
  * Primitive value: An immediate value
  * Collection value: Set, Array
  * Class value: hierarchical value structure to map with the properties in the class
  * Method value: The text which contains method of the object. The canary object notation does not define it's context. The method value can have listener-expression when it is required.

#### examples
````
pi: 3.14
pi: Double 3.14
bounds: Size {width:10.0 height:20.0}
message: Void %{ echo "hello, world !!" %}
enable: Bool (self.a, self.b) %{ return self.a && self.b %}
````

### Identifier
The identifier is started by alphabet. The alphabet, underscore (' ') and digit (0-9)
will follow it.

### Type
#### Primitive Type
* `Bool`: Boolean
* `Int`: 32bit or 64bit signed integer
* `UInt`: 32bit or 64bit unsigned integer
* `Double`:  Double precision floating point number
* `String`: String

#### Collection type
* `Array`:
* `Set`:

### Value
#### Primitive Value
##### Boolean value
`true`, `false`

##### Signed and unsigned integer value
`0`, `-1`, `+3`, `0x123`

##### Floating point value
`0.0`, `-0.123`, `+1.0`

##### String value
The sequence of 2 or more strings will be concatenated and treated as a single string.

``"a"``, ``"Hello, word"``, `"\\\"\n"`.

#### Collection value
##### Array, Set value:
The array and set contains same typed primitive values.
````
[1 2 3] // Estimated as an Array
Array [] // Empty Array
Set [1 2 3]
````

#### Class value
The class value has the hierarchical data structure. It is mapped to the built-in or user defined class.
````
done_button: Button {
  title: "Press me"
  pressed: %{
    app.exit(0)
  %}
}
````

#### Method Value
At the Amber Programming Language, here are 2 kinds of method.

##### Event method
The event method is called by controller when the user action is detected. For example, when the button is pressed by user, the "pressed" method will be called.
````
pressed: Void %{
    /* Event method */
%}
````

The event method does not have return value because there are no object which accepts it.

##### Listener method
The listener method will be called when the context of listening parameter (which is described by path expression) is changed.
````
enable: Bool (self.count) %{
    /* Listener method */
    if (self.count > 1) {
      return true
    } else {
      return false
    }
%}
````
The return value is passed into the property of the owner component.

## Related Links
* *Canary Command Line Parameter Notation*: The [Canary Command Line Parameter Notation](https://github.com/steelwheels/Canary/blob/master/Document/CanaryParameter.md) defines notations to present parameters for command line tools. The text format for the parameter notation uses this notation.
