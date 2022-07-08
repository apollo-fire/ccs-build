for /r %%i in (*.h, *.c, *.cpp) do (
    clang-format -i --style=file "%%i"
)
