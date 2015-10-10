//
//  AppDelegate.swift
//  folderTemplate
//
//  Created by Giuseppe Salvo on 08/10/15.
//  Copyright © 2015 Giuseppe Salvo. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    @IBAction func ReloadFoldersFromMenu(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("ReloadFoldersTable", object: nil)
    }
    @IBAction func ResetApplication(sender: AnyObject) {
        
        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        exit(0)
    
    }
    
    //Quit application on window close
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }

    @IBAction func openTemplateFolders(sender: AnyObject) {
        
        let Utils = Utility()

        if let url = NSUserDefaults.standardUserDefaults().objectForKey( Utils.templateKey ) {
            NSWorkspace.sharedWorkspace().openFile( url as! String , withApplication: "Finder" )
        } else {
            Utils.popup( "Error" , text: "Insert your folder templates in settings" )
        }
        
       
    }
}

