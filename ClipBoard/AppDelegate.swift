//
//  AppDelegate.swift
//  ClipBoard
//
//  Created by Rico Penkalski on 15.04.25.
//

import Cocoa
import SwiftUI


class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var hotkeyMonitor: Any?
    var clipboardHistory: [String] = []
    var lastClipboardContent: String = ""
    var popupWindow: NSWindow?
    var statusMenu: NSMenu?
    
    
    // Startup
    func applicationDidFinishLaunching(_ notification: Notification) {
        setupMenuBar()
        startClipboardMonitoring()
        setupGlobalHotkeyListener()
    }
    
    //adds a Menubar Icon wich is clickable
    func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "doc.on.doc", accessibilityDescription: "Clipboard Manager")
            button.action = #selector(statusbarButtonClicked(_:))
            button.target = self
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }

        updateMenu()
    }

    
    // builds the menu with the last clipboard entries, settings and quit option
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

        statusMenu = menu
    }

    // starts the monitoring for mac clipboard
    func startClipboardMonitoring() {
        lastClipboardContent = NSPasteboard.general.string(forType: .string) ?? ""
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkClipboard), userInfo: nil, repeats: true)
    }
    
    
    // setup a Hotkey to open Popup
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
    
    
    func showPopup(){
        print("showPopup is called!")
        if popupWindow != nil {
            // method needs a param and nil is default
            popupWindow?.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return //????
        }
        
        let popupView = PopupView()
        let hostingController = NSHostingController(rootView: popupView)
        
        // build new NSWindow
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 320, height: 240),
            //style of the window
            styleMask: [.titled, .closable],
            backing: .buffered, defer: false
        )
        
        window.center()
        // input the SwiftUI content
        window.contentView = hostingController.view
        // window stays in memory even when closed
        window.isReleasedWhenClosed = false
        window.title = "Clipboard Popup"
        
        // open window and set active
        window.makeKeyAndOrderFront(nil)
        // floating over others
        window.level = .floating
        // set window active
        NSApp.activate(ignoringOtherApps: true)
        
        
        //safes the reference in Propterty to check if window
        popupWindow = window

    }
    
    
    
    
    
    
    
    
    
    // action if statusBarButton is clicked
    @objc func statusbarButtonClicked(_ sender: NSStatusBarButton) {
        let event = NSApp.currentEvent
        if event?.type == .rightMouseUp {
            updateMenu()
            if let menu = statusMenu, let button = statusItem?.button {
                let location = NSPoint(x: 0, y: button.bounds.height)
                menu.popUp(positioning: nil, at: location, in: button)
            }
        } else {
            showPopup()
        }
    }
    
    
    
    
    // checking for clipboardcontent
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
    
    
    @objc func openSettings() {
        print("Settings clicked!")
    }

    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
