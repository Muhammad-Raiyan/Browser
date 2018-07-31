# Browser

## Zeromq

The contents of this folder should be placed inside of a new folder in *godot/modules/*. And SCsub file has to be modified to include the correct library paths.

## BrowserGUI

After building Godot.exe, this should be imported as a project.

## BrowserNetwork

When the BrowserGUI is running, this node js program needs to be started. It's the networking backend.

## Requirements

* [Godot Source](https://github.com/godotengine/godot) - Version: 3.1 and above

* [SCons](https://www.scons.org/) - Version: 3.0.0-stable, 3.0.1-production

* [CPPZMQ](https://github.com/zeromq/cppzmq.git) - Version Tested: libzmq - 4.2.5, 4.3.0

* [CMake](https://cmake.org/) - Version Tested: 3.11.4 & 3.12.

* [pywin32](https://pypi.org/project/pip/) - Version Tested: 223

## Instructions (Windows)

1. Install CMake, Scons and pywin32 (*optional for parallel builds*)

2. Clone godot, cppzmq and Browser repository

3. Copy `/Browser/ci_build.sh` to `/cppzmq/` overwriting existing `ci_build.sh`.

4. Run `ci_build.sh` to build cppzmq

5. Copy `/Browser/zeromq` to `/godot/modules/`

6. Open `/godot/modules/zeromq/SCsub` and set `cppzmq_location` variable to `/cppzmq/` path (*Make sure you have correct delimiters*)

7. Open x64 Native Tools Command Prompt and cd to `/godot`

8. Run ```scons platform=windows``` to build, add ```vsproj=yes``` to build Visual Studio Solution.

9. If `fatal error LNK1181: cannot open input file 'libzmq-v141-mt-gd-4_2_5.lib.windows.tools.64.lib'` or somethig similar is shown, rename /cppzmq/libzmq-build/lib/Debug/libzmq-v141-mt-gd-4_2_5.lib to missing file name.

10. Copy `/cppzmq/libzmq-build/bin/Debug/libzmq-v141-mt-gd-4_2_5.dll` to `/godot/bin/` directory.

11. Now run `/bin/godot.windows.tools.64.exe` application and import UI as a godot project.

## TODO

1. Update search bar URL on tab switch

2. ~~Clear canvas before inserting new html content~~

3. Add status bar/notification

4. Functional Refresh button

5. Functional Back button/ Browse history

6. ~~Keyboard shortcuts~~
