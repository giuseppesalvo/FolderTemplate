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
    
    @IBOutlet var foldersTable: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        foldersTable.wantsLayer = true

        foldersTable.layer?.borderWidth = 3
        foldersTable.layer?.borderColor = NSColor().CGColor
        
        let documentsUrl = "/Users/Seth/Desktop"
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

}

