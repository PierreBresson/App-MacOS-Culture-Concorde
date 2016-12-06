//
//  CultureConcordeView.swift
//  Culture Concorde
//
//  Created by Pierre Bresson on 19/11/2015.
//  Copyright © 2015 Culture Concorde. All rights reserved.
//

import Cocoa

class CultureConcordeView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        //set background white
        self.layer!.backgroundColor = CGColor(red: 225/225,green: 225/225,blue: 225/225, alpha: 1.0)
    }
    
}
