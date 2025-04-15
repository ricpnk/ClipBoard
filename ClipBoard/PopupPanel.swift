//
//  PopupPanel.swift
//  ClipBoard
//
//  Created by Rico Penkalski on 15.04.25.
//

import Cocoa

class PopupPanel: NSPanel {
    override var canBecomeKey: Bool {
        true
    }
    override var canBecomeMain: Bool {
        true
    }
}
