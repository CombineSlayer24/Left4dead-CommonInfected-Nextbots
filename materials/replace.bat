@echo off
setlocal enabledelayedexpansion

:: Directory path
set "dir=C:\Program Files (x86)\Steam\steamapps\common\GarrysMod\garrysmod\addons\VJ L4D Extended CI\materials"

:: Iterate over .vmt files
for /R "%dir%" %%F in (*.vmt) do (
    :: Print the name of the file being edited
    echo Editing file: %%F
    
    :: Use powershell to edit the file
    powershell -Command "(gc '%%F') -replace '\`$baseTexture \"models/infected/left4dead/', '\`$baseTexture \"models/left4dead/infected/' -replace 'include \"materials/models/infected/left4dead/', 'include \"materials/models/left4dead/infected/' | Out-File -encoding ASCII '%%F'"
)

endlocal
