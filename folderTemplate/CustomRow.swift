//
//  CustomRow.swift
//  folderTemplate
//
//  Created by Giuseppe Salvo on 08/10/15.
//  Copyright © 2015 Giuseppe Salvo. All rights reserved.
//

import Foundation
import Cocoa

class CustomRowSelection: NSTableRowView {
    
    let Util = Utility()
    
    let bgcolor = NSColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        self.wantsLayer = true
        self.layer?.cornerRadius = 2
        self.layer?.masksToBounds = true
        
        self.layer?.borderWidth = 0
        self.layer?.borderColor = NSColor.blueColor().CGColor
        
        if selected == true {
            self.bgcolor.set()
            NSRectFill(dirtyRect)
        }
    }
}

class CustomCell : NSTableCellView {

    @IBOutlet var title: NSTextField!
    
}