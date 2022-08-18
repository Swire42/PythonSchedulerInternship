# Place this file and the relevant sources in a subfolder of https://github.com/foonathan/cppast

add_executable(cppast_bind main.cpp pb.cpp pb.hpp)
target_link_libraries(cppast_bind PUBLIC cppast cxxopts)
set_target_properties(cppast_bind PROPERTIES CXX_STANDARD 20 OUTPUT_NAME bind)
