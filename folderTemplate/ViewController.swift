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
    var documentsUrl :String!
    
    @IBOutlet var foldersTable: NSTableView!

    @IBOutlet var broseTextField: NSTextField!
    @IBOutlet var folderNameTextField: NSTextField!
    
    @IBOutlet var createButton: NSButton!
    @IBOutlet var browseButton: NSButton!
    @IBOutlet weak var settingsButton: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        broseTextField.focusRingType = .None
        folderNameTextField.focusRingType = .None
        
        browseButton.wantsLayer = true
        browseButton.layer?.cornerRadius = 4
        browseButton.layer?.borderWidth = 1
        let colorBlue : NSColor = NSColor( red: 42.0/255, green: 157.0/255, blue: 234.0/255, alpha: 1.0 )
        browseButton.layer?.borderColor = colorBlue.CGColor
        
        createButton.wantsLayer = true
        createButton.layer?.cornerRadius = 4
        createButton.layer?.backgroundColor = colorBlue.CGColor
        
        /*
        NSColor *color = [NSColor greenColor];
        NSMutableAttributedString *colorTitle = [[NSMutableAttributedString alloc] initWithAttributedString:[button attributedTitle]];
        NSRange titleRange = NSMakeRange(0, [colorTitle length]);
        [colorTitle addAttribute:NSForegroundColorAttributeName value:color range:titleRange];
        [button setAttributedTitle:colorTitle];
        */
        
        let coloredTitle : NSMutableAttributedString = NSMutableAttributedString(attributedString: browseButton.attributedTitle ) as NSMutableAttributedString
        let range : NSRange = NSMakeRange(0, coloredTitle.length)
        coloredTitle.addAttribute(NSForegroundColorAttributeName, value: colorBlue, range: range)
        browseButton.attributedTitle = coloredTitle
        
        let coloredTitlee : NSMutableAttributedString = NSMutableAttributedString(attributedString: createButton.attributedTitle ) as NSMutableAttributedString
        let rangee : NSRange = NSMakeRange(0, coloredTitlee.length)
        coloredTitlee.addAttribute(NSForegroundColorAttributeName, value: NSColor.whiteColor(), range: rangee)
        createButton.attributedTitle = coloredTitlee
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadFolders", name:"ReloadFoldersTable", object: nil)
        
        if let docFold = NSUserDefaults.standardUserDefaults().objectForKey( "templatesFolder" ) {
            documentsUrl = docFold as! String
        } else {
            popup("Message", text: "Go to settings and insert your templates folder")
        }
        
        loadFolders()
    }
    
    func reloadTable () {
        if self.folders.count <= 0 {
            self.folders.append("No folders Matched")
        }
        self.foldersTable.reloadData()
    }
    
    func loadFolders () {
        var files : [String]?
        self.folders = []
        
        if let doc = NSUserDefaults.standardUserDefaults().objectForKey( "templatesFolder" ) {
            self.documentsUrl = doc as! String
            let filemanager:NSFileManager = NSFileManager.defaultManager()
            do {
                files = try filemanager.contentsOfDirectoryAtPath(self.documentsUrl)
            } catch let error as NSError {
                print( error )
            }
            
            for f in files! {
                var isDirectory: ObjCBool = false
                filemanager.fileExistsAtPath(self.documentsUrl + "/" + f, isDirectory: &isDirectory)
                if isDirectory {
                    self.folders.append( f )
                }
            }
        }
        
        self.reloadTable()
        
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
        let selRow : Int = ( foldersTable.selectedRow > -1 ? foldersTable.selectedRow : 0 )
        let templatePath = documentsUrl + "/" + folders[ selRow ]
        
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
    @IBAction func reloadTableButton(sender: AnyObject) {
        loadFolders()
    }

    @IBAction func openTemplateFolder(sender: AnyObject) {
        /*
        NSString* folder = @"/path/to/folder"
        [[NSWorkspace sharedWorkspace]openFile:folder withApplication:@"Finder"];
        */
        NSWorkspace.sharedWorkspace().openFile(self.documentsUrl, withApplication: "Finder" )
    }
}

