//
//  AppDelegate.swift
//  macscript
//
//  Created by Ainara Garcia on 6/5/23.
//

import Foundation
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}
