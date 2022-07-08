for /r %%i in (*.h, *.c) do (
    clang-format -i --style=file "%%i"
)

pause
