# Canary Object Notation

## Introduction
The *Canary Object Notation* defines the text format to describe object.

## Copyright
Copyright (C) 2017 [Steel Wheels Project](http://steelwheels.github.io). This document distributed under
[GNU Free Documentation License](https://www.gnu.org/licenses/fdl-1.3.en.html).

## Syntax
### Basic rule
`identifier: type value`
- `identifier` : Name of the object.
- `type`: Data type of object. This is optional. When there are no type declaration, the type will be estimated by the value.
- `values` : Value of the object. There are 3 kind of object:
  * Primitive value: An immediate value
  * Collection value: Set, Array
  * Class value: hierarchical value structure to map with the properties in the class
  * Script value: The text which contains script. The canary object notation does not define it's context.

#### examples
````
pi: 3.14
pi: Float 3.14
bounds: Size {width:10.0 height:20.0}
message: Void %{ echo "hello, world !!" %}
````

### Identifier
The identifier is started by alphabet. The alphabet, underscore (' ') and digit (0-9)
will follow it.

### Type
#### Primitive Type
* `Bool`: Boolean
* `Int`: 32bit or 64bit signed integer
* `UInt`: 32bit or 64bit unsigned integer
* `Float`: Floating point number
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
The array and set contains same typed objects.
Each elements are separated by comma ','.
````
[1, 2, 3]
[{x:0.0 y:1.0} {x:2.0 y:3.0}]
Array [] // Empty Array
Set [1 2 3]
````

If you want to define the set of data, give data type like `a: Set [1 2 3]`. If the type is not given the value will have array type.

#### Class value
The class value has the hierarchical data structure. It is mapped to the built-in or user defined class.
````
done_button: Button {
  label: "Press me"
  button_pressed: %{
    app.exit(0)
  }%
}
````

#### Script Value
The context of the script is *not* checked by the Caray Object Notation decoder. The application uses this format define the context. The type of script value presents the type of return value of execution of the script.
````
    width: Int %{
        return a + b
    }%

    print_initial_message: Void %{
      echo "hello, world !!"
    }%
````
The script can not contain `}%` except the text which is enclosed by '"'.
