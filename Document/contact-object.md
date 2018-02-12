# Contact Object
This document describes about *Contact Object* defined in the Cocoa framework for macOS and iOS.
The `CNAddressBook` class in Canary framework operates this.

## Context of Contact Object
Here is the table of the context of the Contact Object.

|Key  |Symbol |Description        |
|:--- |:---   |:---               |
|identifier |`CNContactIdentifierKey`    |Unique identifier of the contact object |
|contactType |`CNContactTypeKey` |"person" or "organization" |
|namePrefix |`CNContactNamePrefixKey` |Prefix of the name |
|givenName |`CNContactGivenNameKey` |Given name |
|middleName |`CNContactMiddleNameKey` |Middle name |
|familyName |`CNContactFamilyNameKey` |Family name |
|previousFamilyName |`CNContactPreviousFamilyName`| Previous family name|


The symbol is defined in the Swift's framework, not in JavaScript.

## Reference
* [CNContact class](https://developer.apple.com/documentation/contacts/cncontact): Specification of *CNContact* class in Apple developer documentation
* [Contacts Constants](https://developer.apple.com/documentation/contacts/contacts_constants): Constant definition for contact information in Apple developer documentation

## Related links
* [Canary Framework](https://github.com/steelwheels/Canary): The framework to operate contact information
* [Steel Wheels Project](http://steelwheels.github.io): Developer of this software
