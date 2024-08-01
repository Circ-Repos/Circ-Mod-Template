@echo off
color 0a
cd ..
@echo on
echo Installing dependencies.
haxelib install discord_rpc 1.0.0
haxelib install flixel-addons 3.2.3
haxelib install flixel-tools 1.5.1
haxelib install flixel-ui 2.6.1
haxelib install flixel 5.8.0
haxelib install hxCodec 3.0.2
haxelib install hxcpp-debug-server 1.2.4
haxelib install hxcpp 4.3.2
haxelib install hxjsonast 1.1.0
haxelib install json2object 3.11.0
haxelib install lime 8.1.2
haxelib install openfl 9.3.3
haxelib install SScript 8.1.6 
haxelib install tjson 1.4.0
haxelib git flxanimate https://github.com/ShadowMario/flxanimate
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit
haxelib git hxdiscord_rpc https://github.com/MAJigsaw77/hxdiscord_rpc
echo Finished!
pause
