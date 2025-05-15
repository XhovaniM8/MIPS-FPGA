set(VERILATED_SRC_DIR "${CMAKE_CURRENT_BINARY_DIR}/verilated")
file(MAKE_DIRECTORY ${VERILATED_SRC_DIR})

add_custom_command(
    OUTPUT ${VERILATED_SRC_DIR}/Vcontrol.cpp
    COMMAND verilator
            --cc ${CMAKE_SOURCE_DIR}/src/control.sv
            --Mdir ${VERILATED_SRC_DIR}
            -Wall -Wno-fatal
    DEPENDS ${CMAKE_SOURCE_DIR}/src/control.sv
    COMMENT "Running Verilator"
)

add_library(verilated_control STATIC
    ${VERILATED_SRC_DIR}/Vcontrol.cpp
)

target_include_directories(verilated_control PUBLIC
    ${VERILATED_SRC_DIR}
    /opt/homebrew/Cellar/verilator/5.030/share/verilator/include
    /opt/homebrew/Cellar/verilator/5.030/share/verilator/include/vltstd
)

add_custom_target(verilate DEPENDS ${VERILATED_SRC_DIR}/Vcontrol.cpp)
add_dependencies(verilated_control verilate)
