# Canary Object Notation

## Introduction
The *Canary Object Notation* defines the text format to describe object.

## Syntax
### Basic rule
`identifier: type value`
- `identifier` : Name of the object.
- `type`: Data type of object. This is optional. When there are no type declaration, the type will be estimated by the value.
- `values` : Value of the object. There are 3 kind of object:
  * Primitive value: Single immediate value
  * Collection value: Set, Array and Dictionary
  * Script value: The text which contains script. The canary object notation does not define it's context.

#### examples
````
pi: 3.14
pi: Float 3.14
bounds: Size {width:10.0, height:20.0}
message: Void %{ echo "hello, world !!" %}
````

### Identifier
The identifier is started by alphabet. The alphabet, underscore (' ') and digit (0-9)
will follow it.

### Primitive Value
#### Boolean value
`true`, `false`
#### Integer value, Unsigned integer value
`0`, `-1`, `+3`, `0x123`
#### Floating point value
`0.0`, `-0.123`, `+1.0`
#### String value
``"a"``, ``"Hello, word"``, `"\\\"\n"`

The sequence of 2 or more strings will be concatenated and treated as a single string.

### Collection value
#### Array, Set value
The array and set contains same typed objects.
````
[1, 2, 3]
[{x:0.0, y:1.0}, {x:2.0, y:3.0}]
Array [] // Empty Array
Set [1,2,3]
````

If you want to define the set of data, give data type like `a: Set [1,2,3]`. If the type is not given the value will have array type.

#### Dictionary value
The identifier of the object will be used as the key of the dictionary which contains it.
````
{
  member0 : "0"
  member1 : {
    member1a: 123.4
    member1b: "Hello"
  }
}
````
The data type is `Dictionary`.

#### Class object
The *Class object* is similar to dictionary value. But the type declaration (It can not be `Dictionary`) will be required.
````
    done_button: Button {
      label: "Press me"
    }
````

### Script Value
The context of the script is *not* checked by the Caray Object Notation decoder. The application uses this format define the context. The type of script value presents the type of return value of execution of the script.
````
    width: Int %{
        return a + b
    }%

    print_initial_message: Void %{
      echo "hello, world !!"
    }%
````
