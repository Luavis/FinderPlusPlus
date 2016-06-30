//
//  SettingWindow.swift
//  FinderPlusPlus
//
//  Created by Luavis on 6/30/16.
//  Copyright © 2016 Luavis. All rights reserved.
//

import Cocoa


class SettingWindow : NSWindow {
    
    @IBOutlet weak var defaultTerminalMenu: NSMenu!
    @IBOutlet weak var newFileNameTextField: NSTextField!
    @IBOutlet weak var newFileCheckBox: NSButton!
    @IBOutlet weak var copyFilePathCheckBox: NSButton!
    @IBOutlet weak var openInTerminalCheckBox: NSButton!

    static let iTermBundlePath = "com.googlecode.iterm2"
    static let defaultTerminalBundlePath = "com.apple.Terminal"
    static let defaultTerminalKey = "defaultTerminal"

    let iTermPath = NSWorkspace.sharedWorkspace().absolutePathForAppBundleWithIdentifier(SettingWindow.iTermBundlePath)
    let defaultTerminalPath = NSWorkspace.sharedWorkspace().absolutePathForAppBundleWithIdentifier(SettingWindow.defaultTerminalBundlePath)


    override func awakeFromNib() {
        self.fillUpDefaultTerminalSeletion()
    }

    private func fillUpDefaultTerminalSeletion() {
        if let iTermPath = self.iTermPath {
            let iTermIcon = NSWorkspace.sharedWorkspace().iconForFile(iTermPath)
            let iTermBundle = NSBundle(path: iTermPath)!  // must exist!
            let iTermAppName = iTermBundle.objectForInfoDictionaryKey(kCFBundleExecutableKey as String) as! String

            let iTermMenu = NSMenuItem(title: iTermAppName, action: #selector(selectDefaultIterm(_:)), keyEquivalent: iTermAppName)
            iTermMenu.image = iTermIcon
            self.defaultTerminalMenu.addItem(iTermMenu)
        }

        if let defaultTerminalPath = self.defaultTerminalPath {
            let defaultTerminalIcon = NSWorkspace.sharedWorkspace().iconForFile(defaultTerminalPath)
            let defaultTerminalBundle = NSBundle(path: defaultTerminalPath)!  // must exist!
            let defaultTerminalAppName = defaultTerminalBundle.objectForInfoDictionaryKey(kCFBundleExecutableKey as String) as! String

            let defaultTerminalMenu = NSMenuItem(title: defaultTerminalAppName, action: #selector(selectDefaultdefaultTerminal(_:)), keyEquivalent: defaultTerminalAppName)
            defaultTerminalMenu.image = defaultTerminalIcon
            self.defaultTerminalMenu.addItem(defaultTerminalMenu)
        }
    }

    func selectDefaultIterm(sender: AnyObject?) {

    }

    func selectDefaultdefaultTerminal(sender: AnyObject?) {

    }
}
