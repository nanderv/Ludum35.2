SET game=Fluffy_The_Porcupine
dir
rmdir build /s  /Q
mkdir build

jar -cMf build\%game%.love *


xcopy /s c:\Love2D build
cd build
copy %game%.love 32\
copy %game%.love 64\
cd 32
copy /b love.exe+%game%.love %game%.exe
cd ../64
copy /b love.exe+%game%.love %game%.exe
cd ../
xcopy /s 32 Windows_32\
jar -cMf %game%_Win_32.zip %game%_32
xcopy /s 32 Windows_64\
jar -cMf %game%_Win_64.zip %game%_64
rmdir 32 /s /Q
rmdir 64 /s /Q


rmdir Windows_32 /s /Q
rmdir Windows_64 /s /Q



cd ..