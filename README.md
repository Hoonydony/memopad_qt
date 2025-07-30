## memopadqt

Look_at_me - Qt/C++ version

a simple memo pad for shared screen during cc

You can find Python-based Look_at_me at here: [https://github.com/Hoonydony/memopad](https://github.com/Hoonydony/memopad_python)


## Build Instructions

- Qt 6.8.2 or later
- CMake 3.16 or later
- macOS (this project is currently built for macOS)

1. Clone the repository:

   git clone https://github.com/Hoonydony/memopadqt.git 

2. Create a build directory and configure CMake:

   mkdir build

   cmake -S . -B build -DCMAKE_PREFIX_PATH=/path/to/Qt/6.8.2/macos -DCMAKE_BUILD_TYPE=Release

3. Build the Project:
   
   cmake --build build

4. Create a distributable bundle:
   
   cd build

   /path/to/Qt/6.8.2/macos/bin/macdeployqt Look_at_me.app -dmg //the actual directory where you install Qt

5. Open the generated Look_at_me.app from the build directory.


## How to Use

Once you execute the .app, you will have this window that let you name the first tab.
![image](https://github.com/user-attachments/assets/85c28e58-601b-4719-91e9-52d702cbdd2d)

You can switch tabs by clicking the tab bar. If you want to rename a tab, double-click the tab.
![image](https://github.com/user-attachments/assets/2befe7f1-58e8-4ddb-ba25-3dc499fb0694)

You can change the font style independently as you wish.
![image](https://github.com/user-attachments/assets/b9b5d9bb-5d49-4602-beaa-be8ec2938230)

