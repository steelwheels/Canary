Canary Framework
================

Overview
--------
The Canary Framework is a package of general purpose classes
implemented by the [swift language](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/)

Copyright
---------
This software is produced by [Steel Wheels Project](https://sites.google.com/site/steelwheelsproject/) and distributed under
[GNU LESSER GENERAL PUBLIC LICENSE Version 2.1](https://www.gnu.org/licenses/lgpl-2.1-standalone.html).

Classes
-------
* *CNConsole* : Define methods to output text to console. This is abstract class and the output target will be defined by subclasses.
 * *CNTextConsole* : Sub class of CNConsole. This object will be used to output the log into terminal (like terminal application).
 * *CNPipeConsole* : This class is used pipe the console. The object contains the other console object and call methods for it.
 
