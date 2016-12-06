//
//  UpdateViewController.swift
//  Culture Concorde
//
//  Created by Pierre Bresson on 19/04/2016.
//  Copyright © 2016 Culture Concorde. All rights reserved.
//

import Cocoa

class UpdateViewController: NSViewController {

    
    @IBAction func updateYes(_ sender: AnyObject) {
        if let url = URL(string: "http://cultureconcorde.com") {
            NSWorkspace.shared().open(url)
        }
        self.dismiss(UpdateViewController)
    }
    
    @IBAction func updateNo(_ sender: AnyObject) {
        self.dismiss(UpdateViewController)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
