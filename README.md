Canary Framework
================

Overview
--------
The Canary Framework is a package of general purpose data structure classes
implemented by the [swift language](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/).

Copyright
---------
This software is produced by [Steel Wheels Project](https://sites.google.com/site/steelwheelsproject/) and distributed under
[GNU LESSER GENERAL PUBLIC LICENSE Version 2.1](https://www.gnu.org/licenses/lgpl-2.1-standalone.html).

Contents
--------
There is a category list which is supported by this framework.
### File access under SandBox
* [CNFilePath](Classes/CNFilePath.html)
* [CNFileURL](Classes/CNFileURL.html)
* [CNBookmarkPreference](Classes/CNBookmarkPreference.html)
* [CNJSONFile](Classes/CNJSONFile.html)

### Serializer/Deserializer
* [CNSerializer](Classes/CNSerializer.html): Serializer functions for
primitive data structures.

### _State_ class for FSM
* [CNState](Classes/CNState,html)
* [CNCombinedState](Classes/CNCombinedState,html)
* [CNStateObserver](Classes/CNStateObserver,html): Function to trace the modification of CNState object.

### Log output API
This API can be used for not only CLI application but also GUI application.

* [CNConsole](Classes/CNConsole,html): Define API for console access.
* [CNTextConsole](Classes/CNTextConsole,html): Console for the ASCII terminal.
* [CNRedirectConsole](Classes/CNRedirectConsole.html): Console to redirect terminal which can be added/replaced dynamically.
* [CNConsoleText](Classes/CNConsoleText,html): Data structure for log text.

### General purpose extensions
* [CNObjectVisitor](Classes/CNObjectVisitor.html): NSError Extension to support
the visitor patterns for primitive objects.
