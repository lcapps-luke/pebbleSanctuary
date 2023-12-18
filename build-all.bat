lime build html5 -final
del "export/package/pebble-sanctuary-html5.zip"
7z a "export/package/pebble-sanctuary-html5.zip" "./export/html5/bin/*"

lime build windows -final
del "export/package/pebble-sanctuary-windows.zip"
7z a "export/package/pebble-sanctuary-windows.zip" "./export/windows/bin/*"
