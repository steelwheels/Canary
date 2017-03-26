Canary Object Notation
======================

# Introduction
The *Canary Object Notation* defines the text format to describe Swift object.

# Basic Notation
## Syntax
`(label: class values)`
- `label` : Member name in the parent Object
- `class` : Name of class of the Object
- `values` : The value of the object. There are 2 kind of values
  + Primitive value: Immediate values
  + Collection value: Some objects which is contained in the object.

## Primitive Object
````
    (Bool true)
    (Int -1234)
    (UInt 0xabcd)
    (Float -0.1234)
    (String "a" "b" "c")
````

## Collection object
````
    (Array (Int 0)(Int 1)(Int 2))
    (Set (Int 0)(Int 1)(Int 2))
    (Dictionary
      (member_a: Int 0)
      (member_b: Int 1)
    )
````

## Class object
The *Class object* resembles to *Dictionary*. But the class object contains predefined members to present class name, properties and super class of it.
````
    (Class
      (name:  String "class-name")
      (super: Class
        (super_member_a: Int 0)
        (super_member_b: String "b")
      )
      (property: Dictionary
        ...
      )
    )  
````
