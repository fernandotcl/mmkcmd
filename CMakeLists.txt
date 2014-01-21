cmake_minimum_required(VERSION 2.8 FATAL_ERROR)
project(mmkcmd)

add_definitions(-DPROGRAM_NAME=\"${PROJECT_NAME}\")

set(MMKCMD_SOURCES
    src/main.m
    src/MKCKeyListener.m)

set(MMKCMD_HEADERS
    src/MKCKeyListener.h)

include_directories(
    ${PROJECT_SOURCE_DIR}/src)

add_executable(mmkcmd
    ${MMKCMD_SOURCES}
    ${MMKCMD_HEADERS})

set_target_properties(mmkcmd PROPERTIES
    COMPILE_FLAGS "-fobjc-arc -fmodules")

install(TARGETS mmkcmd DESTINATION bin)
