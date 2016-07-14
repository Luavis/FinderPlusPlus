//
//  FinderSync.swift
//  FinderPlusPlusSync
//
//  Created by Luavis on 6/23/16.
//  Copyright © 2016 Luavis. All rights reserved.
//

import Cocoa
import FinderSync
import CoreFoundation


class FinderSync: FIFinderSync {

    var myFolderURL: NSURL = NSURL(fileURLWithPath: "/")
    let xpcConnection: NSXPCConnection = FinderSync.createXPCConnection()

    static internal func createXPCConnection() -> NSXPCConnection {
        let xpcConnection = NSXPCConnection(serviceName: "com.luavis.FinderPlusPlusHelper")
        xpcConnection.remoteObjectInterface = NSXPCInterface(withProtocol: FinderPlusPlusHelperProtocol.self)
        xpcConnection.resume()

        return xpcConnection
    }

    static internal func invalidateXPCConnection(xpcConnection: NSXPCConnection) {
        xpcConnection.invalidate()
    }

    override init() {
        super.init()
        FIFinderSyncController.defaultController().directoryURLs = [self.myFolderURL]
    }

    override func menuForMenuKind(menuKind: FIMenuKind) -> NSMenu {
        let userDefaults = NSUserDefaults(suiteName: "com.luavis")!
        let menu = NSMenu(title: "")

        if userDefaults.boolForKey(Constants.newFileMenuToggleKey) {
            let newFileTitle = NSLocalizedString("New file", comment: "New file")
            menu.addItemWithTitle(newFileTitle, action: #selector(createNewFileSender(_:)), keyEquivalent: "")
        }

        if userDefaults.boolForKey(Constants.openInTerminalToggleKey) {
            let iTermMenuTitle = NSLocalizedString("Open in terminal", comment: "Open in terminal")
            menu.addItemWithTitle(iTermMenuTitle, action: #selector(openInTerminalSender(_:)), keyEquivalent: "")

        }

        if userDefaults.boolForKey(Constants.copyPathToggleKey) {
            let copyPathTitle = NSLocalizedString("Copy path", comment: "Copy path")
            menu.addItemWithTitle(copyPathTitle, action: #selector(copyPathSender(_:)), keyEquivalent: "")
        }

        return menu
    }

    func copyPathSender(sender: AnyObject?) {
        let selectedItems = FIFinderSyncController.defaultController().selectedItemURLs()
        var filePaths:[String] = [String]()

        if let selectedItems = selectedItems {
            for selectedItem in selectedItems {
                let filePath = self.getFilePathFromURL(selectedItem)
                filePaths.append(filePath)
            }

            let copyContent = filePaths.joinWithSeparator("\n")
            NSPasteboard.generalPasteboard().clearContents()
            NSPasteboard.generalPasteboard().declareTypes([NSStringPboardType], owner: self)
            NSPasteboard.generalPasteboard().setString(copyContent, forType: NSStringPboardType)
        }
        else {
            let target = FIFinderSyncController.defaultController().targetedURL()
            self.openInTerminal(target)
        }
    }

    func createNewFileSender(sender: AnyObject?) {
        let target = FIFinderSyncController.defaultController().targetedURL()
        self.createUntitledFile(target)
    }

    func openInTerminalSender(sender: AnyObject?) {

        let selectedItems = FIFinderSyncController.defaultController().selectedItemURLs()

        if let selectedItems = selectedItems {
            for selectedItem in selectedItems {
                self.openInTerminal(selectedItem)
            }
        }
        else {
            let target = FIFinderSyncController.defaultController().targetedURL()
            self.openInTerminal(target)
        }
    }

    deinit {
        FinderSync.invalidateXPCConnection(self.xpcConnection)
    }

    private func getFilePathFromURL(target: NSURL?) -> String {
        if let targetURL = target!.filePathURL {
            return targetURL.path!
        }
        else {
            return ""
        }
    }

    private func openInTerminal(target: NSURL?) {
        if let targetURL = target!.filePathURL {
            xpcConnection.remoteObjectProxy.openTerminal(targetURL, terminalType: .Iterm)
        }
        else {
            print("Open invalid path in terminal")
        }
    }

    private func createUntitledFile(path: NSURL?) {
        if let targetURL = path!.filePathURL {
            let untitledFileNameFormat = NSLocalizedString("untitled file", comment: "untitled file")
            var untitledFileName = untitledFileNameFormat
            var index = 1

            // check untitled file %d is exist
            while true {
                let destURL = targetURL.URLByAppendingPathComponent(untitledFileName)
                if !NSFileManager.defaultManager().fileExistsAtPath(destURL.path!) {
                    break
                } else {
                    untitledFileName = untitledFileNameFormat.stringByAppendingFormat(" %d", index)
                    index += 1
                }
            }

            createNewFile(path, fileName: untitledFileName)
        }
        else {
            print("Create file in invalid path")
        }
    }

    private func createNewFile(path: NSURL?, fileName: String) {
        if let targetURL = path!.filePathURL {
            xpcConnection.remoteObjectProxy.createNewFile(targetURL, fileName: fileName)
        }
        else {
            print("Create file in invalid path")
        }
    }
}

