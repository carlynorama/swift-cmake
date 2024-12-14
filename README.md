# Swift Building CMake & VSCode

(swift-driver version: 1.112.3 Apple Swift version 6.0 (swiftlang-6.0.0.6.8 clang-1600.0.23.1))

https://www.swift.org/documentation/articles/wrapping-c-cpp-library-in-swift.html

## The purpose of This Repo

I would like to use Swift outside the context of the Swift Package Manager. I would like that to be IDE independent (so no heavy reliance on .vscode json). The real trick is how to get sourcekit-lsp versions to understand what my build system already knows. Normally Swift Package Manager does a great job with that, but some of my projects aren't a good fit.

## Anatomy of The Repo

- `.sourcekit-lsp` folder with a `config.json` file. This seems to be the one true file to talk to sourcekit-lsp with that isn't intermingled with IDE specific plugins
- a folder called `Banana` with the source files in it. Decidedly arbitrary. 
- an ignorable `configFileExampleStorage`
- a `.gitignore` that's pretty standard for a swift project, but make sure it has the build folder pattern sited in the build script. 
- A `CMakeLists.txt`. So far running CMake/Ninja with CMake has been the only way I have to generate a valid "where are my files" document that sourcekit-lsp will take. To run CMake you need a CMakeLists.txt file.
- the `build.sh` The script I run to kick off the build. Some of what is done in there could actually be foisted into the CMake, but I also occasionally use a direct call to swiftc at the bottom of the file, too.
- __MISSING:__ The actual working `compile_commands.json` file in the build folder left off the git repo.

## About these files?

### .sourcekit-lsp/config.json

- https://github.com/swiftlang/sourcekit-lsp/blob/main/Documentation/Configuration%20File.md#configuration-file

Sourcekit-lsp has three modes:

 - Swift Project Manager mode triggered by the presence of a Package.swift, honestly the best way.
 - Build Sever Protocol 
 - Compilation Database mode.

 This project is about trying to use Compilation Database mode.

 To that end in the config file I forced the issue by specifying both `"defaultWorkspaceType": "compdb"` and the location of the `"compilationDatabase" :  { "searchPaths": [] }`. In theory the presence of a `compile_commands.json` in the root of the project or a "known build folder" (how does it know? `.build`? `build`? What is the default?) should also do the trick without needing a config.json at all, but one I got the current set up working I did not confirm. 

 __TODO:__ Can I use `generatedFilesPath:` or `index` to side step the need for a separate `compile_commands.json`?

 - https://github.com/swiftlang/sourcekit-lsp/blob/main/Documentation/Configuration%20File.md#configuration-file

 Note: Many of the [examples of this compile_commands.json file](https://github.com/apple/swift-embedded-examples/blob/fc1942bc094947bb2c73fe194d3fc1d207cb418d/stm32-uart-echo/.sourcekit-lsp/config.json#L4) I found are about passing information to the swiftpm mode. Handy to know about, but nothing in that section should be relevant here? 

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

### compile_commands.json

#### General Reference


- https://clangd.llvm.org/design/compile-commands
- https://clang.llvm.org/docs/JSONCompilationDatabase.html
- https://github.com/clangd/coc-clangd/issues/55
- https://github.com/Sarcasm/notes/blob/master/dev/compilation-database.rst#clang
- https://eli.thegreenplace.net/2014/05/21/compilation-databases-for-clang-based-tools


#### Swift Specific 

There is more in the links below from the forum and github.

TL;DR: sourcekit-lsp can use this to figure out how your project fits together. Information it would get from the Package.swift file if you were in swiftpm mode.

### compile_flags.txt

An alternate easier to write style of file that sourcekit-lsp can use... I haven't written a working one yet.

### build.sh

The build script now has two choices, to use CMake or Ninja to generate a `compile_commands.json` file and leave them it the build folder. The config.json specifically calls that location (the build folder) out. Pulling that generated file into the root directory will work, but the generated files have full not relative paths. 

```zsh
## Use CMake compile_commands.json
## set(CMAKE_EXPORT_COMPILE_COMMANDS ON) in the file CMakeLists.txt or the flag below
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=YES -B $BUILDROOT -G Ninja .
if cmake --build $BUILDROOT ; then
    cd $BUILDROOT
    ./$PN
    cd $OLDPWD
fi
```

```zsh
## Use Ninja compile_commands.json
cmake -B $BUILDROOT -G Ninja .
if cmake --build $BUILDROOT ; then
    cd $BUILDROOT
    ninja -t compdb > compile_commands.json
    ./$PN
    cd $OLDPWD
fi
```

You don't really have to ever use the CMake or Ninja build again if you don't add any new files and your commandline build has the same build products. The database will be correct. 

## More Useful Links

### General Swift and IDEs / sourcekit-lsp

- https://github.com/apple/foundationdb/blob/main/SWIFT_IDE_SETUP.md
- https://github.com/swiftlang/sourcekit-lsp/blob/main/Documentation/Editor%20Integration.md 
- https://www.swift.org/documentation/articles/zero-to-swift-emacs.html
- https://feifan.blog/posts/how-to-use-sourcekit-lsp
- https://www.swift.org/documentation/articles/wrapping-c-cpp-library-in-swift.html

### compile_commands/compile_command generators in apple or swiftlang repos
- https://github.com/apple/foundationdb/blob/main/contrib/gen_compile_db.py
- https://github.com/apple/foundationdb/blob/29aa68a3be042cc9c1e03cf106ef7ed1b6ffc854/CMakeLists.txt#L240
- https://github.com/apple/swift-clang/blob/d7403439fc6641751840b723e7165fb02f52db95/test/Index/compile_commands.json#L4
- https://github.com/swiftlang/sourcekit-lsp/blob/3131ca3c81c2895d7e319bb10abab1d9801f4bd9/Sources/BuildSystemIntegration/CompilationDatabase.swift#L158
compile_commands.json

### Related Forum Posts

- https://forums.swift.org/t/vs-code-swift-extension-and-cmake/62086
- https://forums.swift.org/t/sourcekit-lsp-and-cmake/67956
- https://forums.swift.org/t/extending-functionality-of-build-server-protocol-with-sourcekit-lsp/74400
- https://forums.swift.org/t/how-to-use-sourcekit-lsp-to-develop-the-swift-compiler-repo/66167
- https://forums.swift.org/t/sourcekit-lsp-and-cmake/67956/6
- https://forums.swift.org/t/use-a-spm-package-in-a-project-compiled-with-cmake/76211
- (2020) https://forums.swift.org/t/bug-cmake-swift-bad-compile-commands-json/38298
  - https://gitlab.kitware.com/cmake/cmake/-/issues/19443

### Issues that seem related: 
- https://github.com/swiftlang/swift-docc/issues/1105
- https://github.com/swiftlang/vscode-swift/issues/636
- https://github.com/swiftlang/vscode-swift/issues/1208
- https://github.com/swiftlang/vscode-swift/issues/1087
- https://github.com/zed-extensions/swift/issues/13






Still todo - see if I can make a working compile_flags.txt version.


What does it take to get the VSCode editor / Swift plugin to acknowledge the files that the CMake file adds to the target?

What would it take to just YOLO add any .swift files in the workspace to the path?

What if you wanted to add a link to a directory that's not in the workspace? Could you do it through a CMake file? Hardcode the folder in some settings.json file? 

adding CMakePresets.json did not seem to make an immediate difference


Went ahead and created minimal Package.swift, which helped when added [path](https://developer.apple.com/documentation/packagedescription/target/path) / [sources](https://developer.apple.com/documentation/packagedescription/target/sources)? But was being a bit flakey in ways that were hard to reproduce. Had to quit and releaunch a couple of times? Always fine if sources folder was Sources and unspecified, though.  

Interestingly enough, preserved linking even when Package.swift was commented out... until quit and restarted!

Was trying to not use a Package.swift because target project is a bit more free form, and including one seems misleading. But can maybe just add a sacrificial one with a path: "." to just get along in VSCode. Add to gitignore?