//
//  ViewController.swift
//  folderTemplate
//
//  Created by Giuseppe Salvo on 08/10/15.
//  Copyright © 2015 Giuseppe Salvo. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    var folders : Array<String> = []
    let documentsUrl = "/Users/Seth/Desktop"
    
    @IBOutlet var foldersTable: NSTableView!

    @IBOutlet var broseTextField: NSTextField!
    @IBOutlet var folderNameTextField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var files : [String]?
        let filemanager:NSFileManager = NSFileManager.defaultManager()
        do {
            files = try filemanager.contentsOfDirectoryAtPath(documentsUrl)
        } catch let error as NSError {
            print( error )
        }
        
        for f in files! {
            var isDirectory: ObjCBool = false
            filemanager.fileExistsAtPath(documentsUrl + "/" + f, isDirectory: &isDirectory)
            if isDirectory {
                self.folders.append( f )
            }
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
    }
    

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int
    {
        //let numberOfRows:Int = 20
        let numberOfRows:Int = self.folders.count
        return numberOfRows
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {

        let cell : CustomCell = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! CustomCell
        cell.title.stringValue = self.folders[ row ]
        return cell
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject?
    {
        let newString = self.folders[row]
        return newString
    }
    
    func tableView(tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        let myCustomView = CustomRowSelection()
        return myCustomView
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 42
    }
    
    
    @IBAction func broseButton(sender: AnyObject) {
        let openPanel = NSOpenPanel()
        
        openPanel.allowsMultipleSelection  = false
        openPanel.canChooseDirectories     = true
        openPanel.canCreateDirectories     = true
        openPanel.canChooseFiles           = false
        
        openPanel.beginWithCompletionHandler { (result) -> Void in
            if result == NSFileHandlingPanelOKButton {
                
                let url = openPanel.URL?.path
                
                self.broseTextField.stringValue = url!
                
            }
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
    
    @IBAction func CopyTemplate(sender: AnyObject) {
        
        let dest = broseTextField.stringValue
        let foldername = folderNameTextField.stringValue
        let templatePath = documentsUrl + "/" + folders[ foldersTable.selectedRow ]
        
        if broseTextField.stringValue != "" && foldername != "" {
        
            let nsfile : NSFileManager = NSFileManager.defaultManager()
            
            let destPath = dest + "/" + foldername

            do {
            
                try nsfile.copyItemAtPath( templatePath , toPath: destPath  )
                popup("Success", text: "Template copied successfully")
                
            } catch let error as NSError {
            
                popup( "Error while creation" , text: "info: \(error.description)" )
                print( error.description )
            
            }
            
        } else {
            popup( "Error" , text: "Compile all texts" )
        }
    
    }
    

}

