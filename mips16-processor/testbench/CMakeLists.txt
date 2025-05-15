cmake_minimum_required(VERSION 3.15)
project(mips_control_tb LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)

find_program(VERILATOR verilator REQUIRED)

add_subdirectory(src)
add_subdirectory(testbench)

include(FetchContent)
FetchContent_Declare(
  catch2
  GIT_REPOSITORY https://github.com/catchorg/Catch2.git
  GIT_TAG v3.4.0
)
FetchContent_MakeAvailable(catch2)
