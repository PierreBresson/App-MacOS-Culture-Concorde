//
//  Menu.swift
//  Culture Concorde
//
//  Created by Pierre Bresson on 25/02/2016.
//  Copyright © 2016 Culture Concorde. All rights reserved.
//

import Cocoa

@IBDesignable class CPopUpButton: NSPopUpButton {
    
    var defaultImage : NSImage? = NSImage(named: "menu")
    
    @IBInspectable var backgroundImage : NSImage? {
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        // Drawing code here.
        
        if let anImage = self.backgroundImage{
            anImage.draw(in: dirtyRect)
        }else{
            defaultImage?.draw(in: dirtyRect)
        }
    }
}
