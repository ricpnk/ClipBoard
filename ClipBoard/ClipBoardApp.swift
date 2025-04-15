//
//  ClipBoardApp.swift
//  ClipBoard
//
//  Created by Rico Penkalski on 15.04.25.
//

import SwiftUI

@main
struct ClipBoardApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
