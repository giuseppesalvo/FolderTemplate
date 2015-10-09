//
//  SettingsController.swift
//  folderTemplate
//
//  Created by Ampelio on 09/10/15.
//  Copyright © 2015 Giuseppe Salvo. All rights reserved.
//

import Foundation
import Cocoa

class SettingsController: NSViewController {

    @IBOutlet weak var templatesURL: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let docFold = NSUserDefaults.standardUserDefaults().objectForKey( "templatesFolder" ) {
            templatesURL.stringValue = docFold as! String
        }
        
    }
    
    // - - - - - - - - - - - - -
    // MARK: On Appear
    // - - - - - - - - - - - - -
    override func viewDidAppear() {
        super.viewDidAppear()
        
        //Get current window
        let w : NSWindow = self.view.window!
        w.titleVisibility = .Hidden
        w.titlebarAppearsTransparent = true
        w.movableByWindowBackground = true
        w.backgroundColor = NSColor.whiteColor()
    }
    @IBAction func browseFolder(sender: AnyObject) {
        
        let openPanel = NSOpenPanel()
        
        openPanel.allowsMultipleSelection  = false
        openPanel.canChooseDirectories     = true
        openPanel.canCreateDirectories     = true
        openPanel.canChooseFiles           = false
        
        openPanel.beginWithCompletionHandler { (result) -> Void in
            if result == NSFileHandlingPanelOKButton {
                
                let url = openPanel.URL?.path
                
                self.templatesURL.stringValue = url!
                
            }
        }
        
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
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

    @IBAction func SaveFolder(sender: AnyObject) {
        
        let folderURLString = templatesURL.stringValue
        
        if folderURLString != "" {
            
            var isDirectory: ObjCBool = false
            NSFileManager.defaultManager().fileExistsAtPath( folderURLString , isDirectory: &isDirectory)
            
            if isDirectory {
            
                NSUserDefaults.standardUserDefaults().setObject(folderURLString, forKey: "templatesFolder" )
                
                popup("Message", text: "Folder saved successfully")
                
                NSNotificationCenter.defaultCenter().postNotificationName("ReloadFoldersTable", object: nil)
            
            } else {
                popup("Error", text: "The url isn't a folder")
            }
            
            
            
        } else {
            popup("Error", text: "Insert a folder url")
        }
        
    }
}