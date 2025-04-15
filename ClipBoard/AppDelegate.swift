//
//  AppDelegate.swift
//  ClipBoard
//
//  Created by Rico Penkalski on 15.04.25.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var hotkeyMonitor: Any?
    var clipboardHistory: [String] = []
    var lastClipboardContent: String = ""

    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
        startClipboardMonitoring()
        setupGlobalHotkeyListener()
    }

    func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "doc.on.doc", accessibilityDescription: "Clipboard Manager")
        }

        updateMenu()
    }

    func updateMenu() {
        let menu = NSMenu()

        if clipboardHistory.isEmpty {
            let emptyItem = NSMenuItem(title: "Keine Einträge", action: nil, keyEquivalent: "")
            emptyItem.isEnabled = false
            menu.addItem(emptyItem)
        } else {
            for entry in clipboardHistory.prefix(5) {
                let item = NSMenuItem(title: entry, action: #selector(copyEntry(_:)), keyEquivalent: "")
                item.target = self
                menu.addItem(item)
            }
        }

        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Settings", action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))

        statusItem?.menu = menu
    }

    func startClipboardMonitoring() {
        lastClipboardContent = NSPasteboard.general.string(forType: .string) ?? ""
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkClipboard), userInfo: nil, repeats: true)
    }
    
    
    
    
    
    func setupGlobalHotkeyListener(){
        hotkeyMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.keyDown]){
            [weak self] event in guard let self = self else {return}
            
            let isCommandPressed = event.modifierFlags.contains(.command)
            let isShiftPressed = event.modifierFlags.contains(.shift)
            let isVKeyPressed = event.keyCode == 9
            
            if isCommandPressed && isShiftPressed && isVKeyPressed{
                self.showPopup()
            }
            
        }
        
    }
    
    
    
    
    

    @objc func checkClipboard() {
        guard let content = NSPasteboard.general.string(forType: .string) else { return }

        if content != lastClipboardContent {
            //insert the new clipboard content
            lastClipboardContent = content
            clipboardHistory.insert(content, at: 0)
            // remove the last item if its to big
            if clipboardHistory.count > 50 {
                clipboardHistory.removeLast()
            }
            updateMenu()
        }
    }
    
    // copy the clicked entry
    @objc func copyEntry(_ sender: NSMenuItem) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(sender.title, forType: .string)
    }
    
    

    func showPopup(){
        print("showPopup is called!")
    }
    
    
    
    
    
    
    @objc func openSettings() {
        print("Settings clicked!")
    }

    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
