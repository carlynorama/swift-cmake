# Swift Building CMake & VSCode

What does it take to get the VSCode editor / Swift plugin to acknowledge the files that the CMake file adds to the target?

What would it take to just YOLO add any .swift files in the workspace to the path?

What if you wanted to add a link to a directory that's not in the workspace? Could you do it through a CMake file? Hardcode the folder in some settings.json file? 

adding CMakePresets.json did not seem to make an immediate difference


Went ahead and created minimal Package.swift, which helped when added [path](https://developer.apple.com/documentation/packagedescription/target/path) / [sources](https://developer.apple.com/documentation/packagedescription/target/sources)? But was being a bit flakey in ways that were hard to reproduce. Had to quit and releaunch a couple of times? Always fine if sources folder was Sources and unspecified, though.  

Interestingly enough, preserved linking even when Package.swift was commented out... until quit and restarted!

Was trying to not use a Package.swift because target project is a bit more free form, and including one seems misleading. But can maybe just add a sacrificial one with a path: "." to just get along in VSCode. Add to gitignore?

(swift-driver version: 1.112.3 Apple Swift version 6.0 (swiftlang-6.0.0.6.8 clang-1600.0.23.1))


///https://developer.apple.com/documentation/packagedescription/target/path
Discussion
If the path is nil, Swift Package Manager looks for a target’s source files at predefined search paths and in a subdirectory with the target’s name.
The predefined search paths are the following directories under the package root:
Sources, Source, src, and srcs for regular targets
Tests, Sources, Source, src, and srcs for test targets
For example, Swift Package Manager looks for source files inside the [PackageRoot]/Sources/[TargetName] directory.
Don’t escape the package root; that is, values like ../Foo or /Foo are invalid.

https://developer.apple.com/documentation/packagedescription/target/sources
Discussion
If this property is nil, Swift Package Manager includes all valid source files in the target’s path and treats specified paths as relative to the target’s path.
A path can be a path to a directory or an individual source file. In case of a directory, Swift Package Manager searches for valid source files recursively inside it.