## memopadqt

Look_at_me - Qt/C++ version
a simple memo pad for shared screen during cc

You can find Python-based Look_at_me at here: https://github.com/Hoonydony/memopad


## Build Instructions

- Qt 6.8.2 or later
- CMake 3.16 or later
- macOS (this project is currently built for macOS)

1. Clone the repository:
git clone https://github.com/Hoonydony/memopadqt.git cd memopadqt

2. Create a build directory and configure CMake:
mkdir build
cmake -S . -B build -DCMAKE_PREFIX_PATH=/path/to/Qt/6.8.2/macos -DCMAKE_BUILD_TYPE=Release

3. Build the Project:
cmake --build build

4. Create a distributable bundle:
cd build
/path/to/Qt/6.8.2/macos/bin/macdeployqt Look_at_me.app -dmg

5. Open the generated Look_at_me.app from the build directory.
