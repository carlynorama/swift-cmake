## Note, toolchain was installed for all users.
## /Users/$USER/Library/Developer/Toolchains/ for local only
# TOOLCHAINLOC='/Library/Developer/Toolchains/swift-DEVELOPMENT-SNAPSHOT-2024-10-30-a.xctoolchain'

dirname=${PWD##*/} 
dirname=${dirname:-/} 
export PN="MyApp"

REPOROOT=$(git rev-parse --show-toplevel)
BUILDROOT=$REPOROOT/WeirdoBuildFolderName/
SHAREDROOT=$REPOROOT/Shared

# export TOOLCHAINS=$(plutil -extract CFBundleIdentifier raw -o - $TOOLCHAINLOC/Info.plist)
export SHARED=$SHAREDROOT

mkdir -p $BUILDROOT

# ## Use CMake compile_commands.json
# ## set(CMAKE_EXPORT_COMPILE_COMMANDS ON) in the file CMakeLists.txt or the flag below
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=YES -B $BUILDROOT -G Ninja .
if cmake --build $BUILDROOT ; then
    cd $BUILDROOT
    ./$PN
    cd $OLDPWD
fi


## Use Ninja compile_commands.json
# cmake -B $BUILDROOT -G Ninja .
# if cmake --build $BUILDROOT ; then
#     cd $BUILDROOT
#     ninja -t compdb > compile_commands.json
#     ./$PN
#     cd $OLDPWD
# fi


# if swiftc *swift -o $BUILDROOT/$PN ; then
#     cd $BUILDROOT
#     ./$PN
#     cd $OLDPWD
# fi

# if swiftc Banana/*.swift -o $BUILDROOT/$PN ; then
#     cd $BUILDROOT
#     ./$PN
#     cd $OLDPWD
# fi