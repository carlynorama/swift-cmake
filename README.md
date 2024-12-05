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

Tip from an ask:
SourceKitLSP can work with non-SwiftPM projects if you create a compile_commands.json database or you can create a configuration file and populate the compilationDatabase
https://github.com/swiftlang/sourcekit-lsp/blob/main/Documentation/Configuration%20File.md#configuration-file

searching github: https://github.com/apple/swift-embedded-examples/blob/fc1942bc094947bb2c73fe194d3fc1d207cb418d/stm32-uart-echo/.sourcekit-lsp/config.json#L4

```json
{
  "swiftPM": {
    "configuration": "release",
    "triple": "armv7em-apple-none-macho",
    "swiftCompilerFlags": ["-Xfrontend", "-disable-stack-protector"],
    "cCompilerFlags": ["-D__APPLE__", "-D__MACH__"]
  }
}
```

## More Useful Links

- https://clang.llvm.org/docs/JSONCompilationDatabase.html
- https://github.com/swiftlang/sourcekit-lsp/blob/3131ca3c81c2895d7e319bb10abab1d9801f4bd9/Documentation/Using%20SourceKit-LSP%20with%20Embedded%20Projects.md
- https://forums.swift.org/t/sourcekit-lsp-and-cmake/67956
- https://github.com/apple/foundationdb/blob/main/SWIFT_IDE_SETUP.md
- https://github.com/apple/foundationdb/blob/main/contrib/gen_compile_db.py
- https://github.com/apple/foundationdb/blob/29aa68a3be042cc9c1e03cf106ef7ed1b6ffc854/CMakeLists.txt#L240
- https://github.com/apple/swift-clang/blob/d7403439fc6641751840b723e7165fb02f52db95/test/Index/compile_commands.json#L4
- https://github.com/swiftlang/sourcekit-lsp/blob/3131ca3c81c2895d7e319bb10abab1d9801f4bd9/Sources/BuildSystemIntegration/CompilationDatabase.swift#L158
compile_commands.json

seems related: 
- https://github.com/swiftlang/swift-docc/issues/1105
- https://github.com/swiftlang/vscode-swift/issues/636
- https://github.com/swiftlang/vscode-swift/issues/1208
- https://github.com/swiftlang/vscode-swift/issues/1087
- https://github.com/zed-extensions/swift/issues/13