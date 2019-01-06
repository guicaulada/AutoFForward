$ZIPNAME="AutoFForward.zip"
$MOD_DIR="S:\Documents\My Games\FarmingSimulator2019\mods"
$EXE_PATH ="S:\Steam\steamapps\common\Farming Simulator 19\FarmingSimulator2019.exe"

$fs19 = Get-Process FarmingSimulator2019Game -ErrorAction SilentlyContinue
if ($fs19) {
    echo "Stop Farming Simulator 19"
    $fs19 | Stop-Process
    $fs19.WaitForExit()
}

echo "Create new zip"
7z a "-x!*.ps1" "-x!.git" "-x!LICENSE" "-x!*.zip" "-x!*.md" $ZIPNAME * | out-null

echo "Move to mods directory"
cp $ZIPNAME "$MOD_DIR"
rm $ZIPNAME

if ($fs19) {
    echo "Start Farming Simulator 19"
    Start-Process $EXE_PATH
}