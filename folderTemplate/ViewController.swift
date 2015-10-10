//
//  ViewController.swift
//  folderTemplate
//
//  Created by Giuseppe Salvo on 08/10/15.
//  Copyright © 2015 Giuseppe Salvo. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    // - - - - - - - - - - -
    // MARK: Parameters
    // - - - - - - - - - - -
    var folders         : Array<String> = []
    var documentsUrl    : String!
    var thereIsFolders  : Bool!
    
    //
    // Elements in view
    //
    @IBOutlet var foldersTable          : NSTableView!
    @IBOutlet var broseTextField        : NSTextField!
    @IBOutlet var folderNameTextField   : NSTextField!
    @IBOutlet var createButton          : NSButton!
    @IBOutlet var browseButton          : NSButton!
    @IBOutlet weak var settingsButton   : NSButton!
    
    
    //
    // Custom Classes
    //
    let Utils = Utility()
    
    
    // - - - - - - - - - - - - -
    // MARK: View Did Load
    // - - - - - - - - - - - - -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style Interface
        self.styleInterface()
        
        // Check if it's first open
        if let docFold = NSUserDefaults.standardUserDefaults().objectForKey( Utils.templateKey ) {
            documentsUrl = docFold as! String
        } else {
            Utils.popup("Message", text: "Go to settings and insert your templates folder")
        }
        
        // Load folders
        loadFolders()
        
        // Add an Observer for reload table from any controller
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadFolders", name:"ReloadFoldersTable", object: nil)
    }
    
    //
    // Set style of interface
    //
    func styleInterface () {
        Utils.styleText( broseTextField, folderNameTextField )
        
        Utils.styleButton( browseButton, cornerRadius: 4, borderWidth: 1, background: false , whiteText: false )
        Utils.styleButton( createButton, cornerRadius: 4, borderWidth: 0, background: true  , whiteText: true  )
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
    
    // - - - - - - - - - - - -
    // MARK: Folder Table View
    // - - - - - - - - - - - -
    
    //
    // Reload Table View Data
    //
    func reloadTable () {
        if self.folders.count <= 0 {
            self.folders.append("No folders Matched")
            self.thereIsFolders = false
        } else {
            self.thereIsFolders = true
        }
        self.foldersTable.reloadData()
    }
    
    //
    // Load Folders from url
    //
    func loadFolders () {
        var files : [String]?
        self.folders = []
        
        if let doc = NSUserDefaults.standardUserDefaults().objectForKey( Utils.templateKey ) {
            
            self.documentsUrl = doc as! String
            let filemanager:NSFileManager = NSFileManager.defaultManager()
            
            do {
                
                files = try filemanager.contentsOfDirectoryAtPath( self.documentsUrl )
                
                for f in files! {
                    let path = self.documentsUrl + "/" + f
                    if Utils.isADirectory( path ) {
                        self.folders.append( f )
                    }
                }
                
            } catch let error as NSError {
                Utils.popup( "Error" , text: "Error while reading folder" )
                print( error )
            }
        }
        
        self.reloadTable()
        
    }
    
    //
    // Table View's delegate
    //
    
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int
    {
        let numberOfRows : Int = self.folders.count
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
    
    // - - - - - - - -
    // MARK: Browse Button
    // - - - - - - - -
    
    @IBAction func broseButton(sender : NSButton ) {
        
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
                
                self.broseTextField.stringValue = url!
                
            }
        }
        
    }
    
    // - - - - - - - - - - - - - - - - - - - - - -
    // MARK: Copy template to destination folder
    // - - - - - - - - - - - - - - - - - - - - - -
    func Copy () {
        let dest         = broseTextField.stringValue
        let foldername   = folderNameTextField.stringValue
        let selRow : Int = ( foldersTable.selectedRow > -1 ? foldersTable.selectedRow : 0 )
        let templatePath = documentsUrl + "/" + folders[ selRow ]
        
        if broseTextField.stringValue != "" && foldername != "" {
            
            if Utils.isADirectory( dest ) {
                
                let nsfile : NSFileManager = NSFileManager.defaultManager()
                
                let destPath = dest + "/" + foldername
                
                do {
                    
                    try nsfile.copyItemAtPath( templatePath , toPath: destPath  )
                    Utils.popup("Success", text: "Template copied successfully")
                    
                } catch let error as NSError {
                    
                    Utils.popup( "Error while creation" , text: "info: \(error.description)" )
                    print( error.description )
                    
                }
                
            } else {
                
                Utils.popup( "Error" , text: "Destination isn't a directory" )
                
            }
            
            
            
        } else {
            
            Utils.popup( "Error" , text: "Compile all texts" )
            
        }
    }
    
    @IBAction func CopyTemplate(sender: NSButton ) {
        
        if let _ = self.view.window?.nextEventMatchingMask( Int( NSEventMask.LeftMouseDownMask.rawValue ) ) {
            sender.alphaValue = 0.6
        }
        
        if let _ = self.view.window?.nextEventMatchingMask( Int( NSEventMask.LeftMouseUpMask.rawValue ) ) {
            sender.alphaValue = 1
        }
        
        
        if self.thereIsFolders == true {
            Copy()
        } else {
            Utils.popup( "Error", text: "No templates matched" )
        }
    
    }
    
    
    // Reload table from button
    @IBAction func reloadTableButton(sender: AnyObject) {
        loadFolders()
    }

}

