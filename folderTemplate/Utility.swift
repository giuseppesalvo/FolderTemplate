//
//  StyleController.swift
//  vHosts
//
//  Created by Ampelio on 09/07/15.
//  Copyright (c) 2015 Giuseppe Salvo. All rights reserved.
//

import Cocoa
import Foundation
import QuartzCore

class Utility {
    
    let templateKey : String = "TemplateFolders"
    
    let baseColor : NSColor = NSColor( red: 42.0/255, green: 157.0/255, blue: 234.0/255, alpha: 1.0 )
    
    //Set window style
    func styleWindow( window : NSWindow... ) {
        
        for w in window {
            // Remove title bar
            w.titleVisibility            = .Hidden
            w.titlebarAppearsTransparent = true
            w.movableByWindowBackground  = true
            w.backgroundColor            = NSColor.whiteColor()
        }
        
    }
    
    //Set styles for all text
    func styleText( text : NSTextField... ) {
        
        for t in text {
            t.focusRingType = .None
        }
        
    }
    
    //Set styles for all buttons
    func styleButton( button : NSButton, cornerRadius : CGFloat, borderWidth : CGFloat, background: Bool, whiteText: Bool   ) {

        button.wantsLayer = true
        button.layer?.cornerRadius = cornerRadius
        button.layer?.borderWidth = borderWidth
        button.layer?.borderColor = self.baseColor.CGColor
        if background {
            button.layer?.backgroundColor = self.baseColor.CGColor
        }
        
        let textColor : NSColor = ( whiteText ? NSColor.whiteColor() : self.baseColor )
        
        let coloredTitle = NSMutableAttributedString( attributedString: button.attributedTitle )
        let range : NSRange = NSMakeRange(0, coloredTitle.length )
        coloredTitle.addAttribute(NSForegroundColorAttributeName, value: textColor, range: range)
        button.attributedTitle = coloredTitle
        
    }
    
    
    // Create dialog box on screen
    func popup(question: String, text: String) -> Bool {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = question
        myPopup.informativeText = text
        myPopup.alertStyle = NSAlertStyle.WarningAlertStyle
        myPopup.addButtonWithTitle("OK")
        let res = myPopup.runModal()
        if res == 1000 {
            return true
        }
        return false
    }
    
    func isADirectory( path: String ) -> ObjCBool {
        
        var isDirectory: ObjCBool = false
        NSFileManager.defaultManager().fileExistsAtPath( path , isDirectory: &isDirectory)
        
        return isDirectory
        
    }
    
}
