$ZIPNAME="AutoFForward.zip"
$MOD_DIR="S:\Documents\My Games\FarmingSimulator2022\mods"
$EXE_PATH="S:\Steam\steamapps\common\Farming Simulator 22\FarmingSimulator2022.exe"
$SRV_PATH="S:\Farming Simulator 2022\FarmingSimulator2022.exe"
$fs22 = Get-Process FarmingSimulator2022Game -ErrorAction SilentlyContinue
if ($fs22) {
    echo "Stop Farming Simulator 22"
    $fs22 | Stop-Process
    $fs22.WaitForExit()
}
echo "Create new zip"
7z a "-x!*.ps1" "-x!.git" "-x!LICENSE" "-x!*.zip" "-x!*.md" "-x!*.gitignore" $ZIPNAME * | out-null
echo "Move to mods directory"
cp $ZIPNAME "$MOD_DIR"
rm $ZIPNAME
if ($fs22) {
    echo "Start Farming Simulator 22"
    Start-Process $SRV_PATH -ArgumentList '-server'
    Start-Process $EXE_PATH
}