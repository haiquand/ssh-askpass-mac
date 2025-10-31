//
//  ssh-askpass-mac.swift
//  ssh-askpass-mac
//
//  Created by haiquand on 2025/10/3.
//
//  SPDX-License-Identifier: MIT
//

import Cocoa
import SwiftUI


@main
struct MyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Read command line arguments
        let info = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : ""

        // Create a minimal window — the size will be adjusted later
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 200, height: 200),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = "ssh-askpass-mac"
        window.titlebarAppearsTransparent = true
        window.isMovableByWindowBackground = true
        
        // Create SwiftUI contentView
        let contentView = ContentView(info: info)
        let hostingController = NSHostingController(rootView: contentView)
        
        // Assign the SwiftUI hosting controller as window content
        window.contentViewController = hostingController
        
        // Use SwiftUI layout system to compute ideal window size
        let targetSize = hostingController.sizeThatFits(in: NSSize(
            width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        window.setContentSize(targetSize)
        
        // Center window
        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame
            let windowSize = window.frame.size
            let origin = NSPoint(
                x: screenFrame.midX - windowSize.width / 2,
                y: screenFrame.midY - windowSize.height / 2
            )
            window.setFrameOrigin(origin)
        }
        
        // Make window key and visible
        window.makeKeyAndOrderFront(nil)
        
        // Use .accessory mode:
        // - App won't appear in Dock
        // - App won't appear in Command-Tab switcher
        //
        // Note:
        // - Need to add `UIElement: False` to info.plist
        NSApp.setActivationPolicy(.accessory)
        
        // Activate the app and bring window to front
        NSApp.activate(ignoringOtherApps: true)
    }
    
    // Auto quit after last window is closed
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
