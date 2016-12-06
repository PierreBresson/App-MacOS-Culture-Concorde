//
//  AppDelegate.swift
//  Culture Concorde
//
//  Created by Pierre Bresson on 10/11/2015.
//  Copyright © 2015 Culture Concorde. All rights reserved.
//

import Cocoa
import PopStatusItem
import SPMediaKeyTap

protocol musicDelegate {
    func setupMediaTap()
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var mediaTap: SPMediaKeyTap?

    var popStatusItem = PopStatusItem(image: NSImage(named: "appIcon")!)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        popStatusItem.windowController = storyboard.instantiateController(withIdentifier: "PopStatusItem") as? NSWindowController
        
        popStatusItem.popover.appearance = NSAppearance(named: NSAppearanceNameAqua)
        
        
        popStatusItem.highlight = false // Default is false
        popStatusItem.activate = false // Default is false
        
        popStatusItem.showPopover() // Show popover on startup
        
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    

}

