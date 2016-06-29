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
        let xpcConnection = NSXPCConnection(serviceName: "luavis.FinderPlusPlusHelper")
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
        let iTermMenuTitle = NSLocalizedString("Open in terminal", comment: "Open in terminal")
        let newFileTitle = NSLocalizedString("New file", comment: "New file")

        let menu = NSMenu(title: "")
        menu.addItemWithTitle(iTermMenuTitle, action: #selector(openInTerminalSender(_:)), keyEquivalent: "")
        menu.addItemWithTitle(newFileTitle, action: #selector(createNewFileSender(_:)), keyEquivalent: "")

        return menu
    }

    func createNewFileSender(sender: AnyObject?) {
        let target = FIFinderSyncController.defaultController().targetedURL()

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

    private func openInTerminal(target: NSURL?) {
        if let targetURL = target!.filePathURL {
            xpcConnection.remoteObjectProxy.openTerminal(targetURL, terminalType: .Iterm)
        }
        else {
            print("Open invalid path in terminal")
        }
    }

    private func createNewFile(path: NSURL?, fileName: NSString) {
        if let targetURL = path!.filePathURL {
            xpcConnection.remoteObjectProxy.createFile(targetURL, fileName: fileName)
        }
        else {
            print("Create file in invalid path")
        }
    }
}

