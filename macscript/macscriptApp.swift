//
//  macscriptApp.swift
//  macscript
//
//  Created by Jan Garcia on 5/5/23.
//

import SwiftUI

@main
struct macscriptApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .orange]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .brightness(-0.05)
                    .scaleEffect(2.5)
                    .edgesIgnoringSafeArea(.all)
                UserFlowView()
                    .onReceive(NotificationCenter.default.publisher(for: NSApplication.willUpdateNotification), perform: { _ in
                        for window in NSApplication.shared.windows {
                            window.standardWindowButton(.zoomButton)?.isEnabled = false
                        }
                    })
            }
        }
    }
}

public enum Step {
    case MAIN_MENU, PALERA1N, TERMINAL
}
