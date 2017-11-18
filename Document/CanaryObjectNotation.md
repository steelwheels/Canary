# Canary Object Notation

## Introduction
The *Canary Object Notation* defines the text format to describe object. It looks like JSON, but this notation contains type information.

## Copyright
Copyright (C) 2017 [Steel Wheels Project](http://steelwheels.github.io). This document distributed under
[GNU Free Documentation License](https://www.gnu.org/licenses/fdl-1.3.en.html).

## Download
- [Canary Framework](https://github.com/steelwheels/Canary): Source code repository which implements Canary Object Notation

## Syntax
The notation defines the object.

`identifier: type value`
  - `identifier` : Name of the object.
  - `type`: Class (Data type) of the object.
  - `values` : Value of the object.

The object is categorized into followings:
  * *Primitive object*: Object for primitive values such as boolean value, character value, integer value, etc ...
  * *Class object*: Hierarchical structure to map object to properties.
  * *Method object*: The text which contains method of the object. The canary object notation does not define it's context. The method value can have listener-expression when it is required.

## Primitive Object
Define the primitive-object and assign initial value.
Syntax:

````instance-name: primitive-type immediate-value````

<table>
<tr>
  <th>Type</th><th>Value</th><th>Description</th>
</tr>
<tr>
  <td>Bool</td><td>true, false</td><td>Boolean value</td>
</tr>
<tr>
  <td>Int</td><td>1,+123,-234, 0xf, ...</td><td>Signed integer value</td>
</tr>
<tr>
  <td>UInt</td><td>1,123,0xe, ...</td><td>Unsigned integer value</td>
</tr>
<tr>
  <td>Double</td><td>1.23, -0.59, ...</td><td>Floating point value</td>
</tr>
<tr>
  <td>String</td><td>"Hello, world", ...</td><td>String value</td>
</tr>
</table>

### Class object
Define class-object. Syntax:
````
instance-name: class-name {
   property-object
   property-object
   ...
}
````

## Method object
There are some kinds of method.

### Normal method
The *normal method* is called by the other methods with some parameters
````
instance-name: ret-type (parameter, parameter, ...) %{
    /* method body */
%}
````
### Event method
The *event method* is used as the callback function without parameters.
````
instance-name: ret-type %{
    /* method body */
%}
````
### Listener method
The *listener method* is used as the react function. It is called when the at least one listening parameter's value is updated.
````
instance-name: ret-type [listening-param, listening-param, ... ] %{
    /* method body */
%}
````

## Sample code
### Primitive object
The string object whose initial value is "Hello, world !!".
````
message: String "Hello, world !!"
````

### Built-in class object
````
done_button: Button {
  title: "Press me"
  pressed: %{
    app.exit(0)
  %}
}
````

### Listener method
The listener method will be called when the context of listening parameter (which is described by one or more path expressions) is changed.
````
enable: Bool [self.count] %{
    /* Listener method */
    if (self.count > 1) {
      return true
    } else {
      return false
    }
%}
````
The return value is passed into the property.

### Object connection
The input and output of the shell are redirect into the console view.
````
window: Window {
  shell: Shell {
    connection: Connection > window.consoleView.console
  }
  consoleView: ConsoleView {
    /* console */
  }
}
````

## Related Links
* *Canary Command Line Parameter Notation*: The [Canary Command Line Parameter Notation](https://github.com/steelwheels/Canary/blob/master/Document/CanaryParameter.md) defines notations to present parameters for command line tools. The text format for the parameter notation uses this notation.
