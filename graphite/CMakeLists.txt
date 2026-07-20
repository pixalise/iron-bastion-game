cmake_minimum_required(VERSION 3.22)

project(graphite
	VERSION 0.1.0
	DESCRIPTION "Native C++ GDExtension simulation layer for Iron Bastion."
	LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(GRAPHITE_GODOT_CPP_DIR "${CMAKE_CURRENT_SOURCE_DIR}/godot-cpp" CACHE PATH
	"Path to the Godot C++ bindings checkout."
)
set(GRAPHITE_GODOT_PROJECT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/.." CACHE PATH
	"Path to the Godot project root."
)

if(NOT EXISTS "${GRAPHITE_GODOT_CPP_DIR}/CMakeLists.txt")
	message(FATAL_ERROR
		"Missing godot-cpp CMake project at ${GRAPHITE_GODOT_CPP_DIR}. "
		"Clone the Godot C++ bindings into graphite/godot-cpp before configuring."
	)
endif()

set(GODOTCPP_TARGET "template_debug" CACHE STRING "Godot extension target.")
set(GODOTCPP_USE_HOT_RELOAD ON CACHE BOOL "Enable Godot C++ hot reload support.")

add_subdirectory("${GRAPHITE_GODOT_CPP_DIR}" "${CMAKE_BINARY_DIR}/godot-cpp")

add_library(graphite SHARED
	include/graphite_math.hpp
	include/register_types.hpp
	src/graphite_math.cpp
	src/register_types.cpp
)

target_include_directories(graphite PRIVATE include)

if(TARGET godot::cpp)
	target_link_libraries(graphite PRIVATE godot::cpp)
elseif(TARGET godot-cpp)
	target_link_libraries(graphite PRIVATE godot-cpp)
else()
	message(FATAL_ERROR "godot-cpp CMake target was not created.")
endif()

set_target_properties(graphite PROPERTIES
	LIBRARY_OUTPUT_DIRECTORY "${GRAPHITE_GODOT_PROJECT_DIR}/addons/graphite/bin"
	RUNTIME_OUTPUT_DIRECTORY "${GRAPHITE_GODOT_PROJECT_DIR}/addons/graphite/bin"
	ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib"
)

if(DEFINED GODOTCPP_SUFFIX)
	set_target_properties(graphite PROPERTIES OUTPUT_NAME "graphite${GODOTCPP_SUFFIX}")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
	set_target_properties(graphite PROPERTIES OUTPUT_NAME "graphite.linux.template_debug.x86_64")
endif()
