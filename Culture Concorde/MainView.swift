//
//  MainView.swift
//  Culture Concorde
//
//  Created by Pierre Bresson on 19/11/2015.
//  Copyright © 2015 Culture Concorde. All rights reserved.
//

import Cocoa

class MainView: NSView {


    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override func viewDidMoveToWindow() {
        let superView = window?.contentView?.superview
        let bgView = CultureConcordeView(frame: superView!.bounds)
        
        superView!.addSubview(bgView, positioned: .below, relativeTo: superView)
        
        super.viewDidMoveToWindow()
    }
    
}
