"use strict";
exports.__esModule = true;
console.log("ELECTRON");
var electron_1 = require("electron");
function createWindow() {
    var win = new electron_1.BrowserWindow({
        width: 640,
        height: 720
    });
    win.loadFile('index.html');
}
electron_1.app.whenReady().then(function () {
    createWindow();
    electron_1.app.on('activate', function () {
        if (electron_1.BrowserWindow.getAllWindows().length === 0)
            createWindow();
    });
});
electron_1.app.on('window-all-closed', function () {
    if (process.platform !== 'darwin')
        electron_1.app.quit();
});
