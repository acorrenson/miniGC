project(MINI-GC C)
set(CMAKE_C_COMPILER "/usr/bin/clang")
set(CMAKE_C_FLAGS "-Wall -Wextra -Wreturn-type -Werror=return-type -Wunreachable-code")

add_executable(test parser.c utils.c gc.c vm.c test.c)
