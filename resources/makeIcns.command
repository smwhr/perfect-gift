cd "`dirname "$0"`"

# http://stackoverflow.com/questions/12306223/how-to-manually-create-icns-files-using-iconutil
mkdir Icon.iconset
sips -z 16 16     Icon1024.png --out Icon.iconset/icon_16x16.png
sips -z 32 32     Icon1024.png --out Icon.iconset/icon_16x16@2x.png
sips -z 32 32     Icon1024.png --out Icon.iconset/icon_32x32.png
sips -z 64 64     Icon1024.png --out Icon.iconset/icon_32x32@2x.png
sips -z 128 128   Icon1024.png --out Icon.iconset/icon_128x128.png
sips -z 256 256   Icon1024.png --out Icon.iconset/icon_128x128@2x.png
sips -z 256 256   Icon1024.png --out Icon.iconset/icon_256x256.png
sips -z 512 512   Icon1024.png --out Icon.iconset/icon_256x256@2x.png
sips -z 512 512   Icon1024.png --out Icon.iconset/icon_512x512.png

sips -z 107 107     Icon1024.png --out ../src-tauri/icons/Square107x107Logo.png
sips -z 142 142     Icon1024.png --out ../src-tauri/icons/Square142x142Logo.png
sips -z 150 150     Icon1024.png --out ../src-tauri/icons/Square150x150Logo.png
sips -z 284 284     Icon1024.png --out ../src-tauri/icons/Square284x284Logo.png
sips -z 30 30   	Icon1024.png --out ../src-tauri/icons/Square30x30Logo.png
sips -z 310 310   	Icon1024.png --out ../src-tauri/icons/Square310x310Logo.png
sips -z 44 44   	Icon1024.png --out ../src-tauri/icons/Square44x44Logo.png
sips -z 71 71   	Icon1024.png --out ../src-tauri/icons/Square71x71Logo.png
sips -z 89 89   	Icon1024.png --out ../src-tauri/icons/Square89x89Logo.png
sips -z 72 72   	Icon1024.png --out ../src-tauri/icons/StoreLogo.png
sips -z 32 32     	Icon1024.png --out ../src-tauri/icons/32x32.png
sips -z 128 128   	Icon1024.png --out ../src-tauri/icons/128x128.png
sips -z 256 256   	Icon1024.png --out ../src-tauri/icons/128x128@2x.png

#cp Icon1024.png Icon.iconset/icon_512x512@2x.png
#iconutil -c icns Icon.iconset
#rm -R Icon.iconset