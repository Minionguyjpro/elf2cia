
@set /p unique_id= "Insert cia Unique ID (Example: 0xAAAAAA): "
@cd stuffs
@echo Starting Crap, please wait...
@echo.
@echo Creating icon and banner files...
@bannertool makebanner -i ../files/banner.png -a ../files/audio.wav -o ../tmp/banner.bin
@bannertool makesmdh -s "Homebrew" -l "Homebrew" -p "Smea" -i ../files/icon.png -o ../tmp/icon.bin
@echo Creating romfs file...
@3dstool -cvtf romfs ../tmp/romfs.bin --romfs-dir ../romfs
@echo Building cia file...
@hex_set %unique_id%
@makerom -f cia -o ../Game.cia -elf Game.elf -rsf cia_workaround.rsf -icon ../tmp/icon.bin -banner ../tmp/banner.bin -exefslogo -target t -romfs ../tmp/romfs.bin
@cd ..
@echo Deleting temp files...
@del /q ".\tmp\*.*"
@echo Video converted successfully!
@set /p dummy= "Press ENTER to exit"