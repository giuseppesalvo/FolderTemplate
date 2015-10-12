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
    
    
    // - - - - - - - - - - -
    // MARK: Parameters
    // - - - - - - - - - - -
    @IBOutlet weak var templatesURL: NSTextField!
    @IBOutlet var browseButton: NSButton!
    @IBOutlet var saveButton: NSButton!
    
    
    //
    // Custom Classes
    //
    let Utils = Utility()
    
    // - - - - - - - - - - -
    // MARK: View Did Load
    // - - - - - - - - - - -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style Interface
        self.styleInterface()
        
        // Compile templatesURL TExt Field if a templates folder already exists in nsuserdefault
        if let docFold = NSUserDefaults.standardUserDefaults().objectForKey( Utils.templateKey ) {
            templatesURL.stringValue = docFold as! String
        }
        
    }
    
    func styleInterface () {
        
        Utils.styleButton(browseButton, cornerRadius: 4, borderWidth: 1, background: false, whiteText: false)
        Utils.styleButton(saveButton, cornerRadius: 4, borderWidth: 0, background: true, whiteText: true)
        Utils.styleText( templatesURL )
        
    }
    
    // - - - - - - - - - - - - -
    // MARK: On Appear
    // - - - - - - - - - - - - -
    override func viewDidAppear() {
        super.viewDidAppear()
        
        //Get current window
        let w : NSWindow = self.view.window!
        Utils.styleWindow( w )
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
    // - - - - - - - - - - - - - -
    // MARK: App functionality
    // - - - - - - - - - - - - - -
    
    //
    // Browse a folder
    //
    @IBAction func browseFolder(sender: NSButton ) {
        
        if let _ = self.view.window?.nextEventMatchingMask( Int( NSEventMask.LeftMouseDownMask.rawValue ) ) {
            sender.alphaValue = 0.6
        }
        
        if let _ = self.view.window?.nextEventMatchingMask( Int( NSEventMask.LeftMouseUpMask.rawValue ) ) {
            sender.alphaValue = 1
        }
        
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

    @IBAction func SaveFolder(sender: NSButton ) {
        
        if let _ = self.view.window?.nextEventMatchingMask( Int( NSEventMask.LeftMouseDownMask.rawValue ) ) {
            sender.alphaValue = 0.6
        }
        
        if let _ = self.view.window?.nextEventMatchingMask( Int( NSEventMask.LeftMouseUpMask.rawValue ) ) {
            sender.alphaValue = 1
        }
        
        let folderURLString = templatesURL.stringValue
        
        if folderURLString != "" {
            
            if Utils.isADirectory( folderURLString ) {
            
                NSUserDefaults.standardUserDefaults().setObject(folderURLString, forKey: Utils.templateKey )
                
                Utils.popup("Message", text: "Folder successfully saved")
                
                NSNotificationCenter.defaultCenter().postNotificationName("ReloadFoldersTable", object: nil)
            
            } else {
                Utils.popup("Error", text: "This url isn't a folder")
            }
            
        } else {
            Utils.popup("Error", text: "Write the url")
        }
        
    }
}