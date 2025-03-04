cmake_minimum_required(VERSION 3.16)

project(Look_at_me VERSION 0.2 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.2 COMPONENTS Quick Widgets REQUIRED)

qt_add_executable(Look_at_me
    main.cpp
    backend.cpp
    backend.h
)

qt_add_qml_module(Look_at_me
    URI Look_at_me
    VERSION 1.0
    QML_FILES main.qml
    RESOURCES resources.qrc
)

target_link_libraries(Look_at_me
    PRIVATE Qt6::Quick Qt6::Widgets
)

# Define the icon file
set(ICON_FILE ${CMAKE_SOURCE_DIR}/images/cake.icns)

# Ensure the .icns file is copied to the Resources directory in the bundle
set_source_files_properties(${ICON_FILE} PROPERTIES MACOSX_PACKAGE_LOCATION Resources)

# Explicitly add the icon file to the target's sources
target_sources(Look_at_me PRIVATE ${ICON_FILE})

# Custom command to ensure the Resources directory exists and copy the .icns file
add_custom_command(TARGET Look_at_me POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory $<TARGET_BUNDLE_DIR:Look_at_me>/Contents/Resources
    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${ICON_FILE} $<TARGET_BUNDLE_DIR:Look_at_me>/Contents/Resources/
    COMMENT "Copying cake.icns to Resources directory in the app bundle"
)

set_target_properties(Look_at_me PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER me.hoonydony.look_at_me
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    MACOSX_BUNDLE_ICON_FILE cake.icns
    WIN32_EXECUTABLE TRUE
)

install(TARGETS Look_at_me
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})
