## Note, toolchain was installed for all users.
## /Users/$USER/Library/Developer/Toolchains/ for local only
# TOOLCHAINLOC='/Library/Developer/Toolchains/swift-DEVELOPMENT-SNAPSHOT-2024-10-30-a.xctoolchain'

dirname=${PWD##*/} 
dirname=${dirname:-/} 
export PN="MyApp"

REPOROOT=$(git rev-parse --show-toplevel)
BUILDROOT=$REPOROOT/build/
SHAREDROOT=$REPOROOT/Shared

# export TOOLCHAINS=$(plutil -extract CFBundleIdentifier raw -o - $TOOLCHAINLOC/Info.plist)
export SHARED=$SHAREDROOT

mkdir -p $BUILDROOT

# cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=YES -B $BUILDROOT -G Ninja .
# # cmake -B $BUILDROOT -G Ninja .
# if cmake --build $BUILDROOT ; then
#     cd $BUILDROOT
#     ./$PN
#     cd $OLDPWD
# fi


# if swiftc *swift -o $BUILDROOT/$PN ; then
#     cd $BUILDROOT
#     ./$PN
#     cd $OLDPWD
# fi

if swiftc Banana/*.swift -o $BUILDROOT/$PN ; then
    cd $BUILDROOT
    ./$PN
    cd $OLDPWD
fi