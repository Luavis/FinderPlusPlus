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

    let iTermPath = NSWorkspace.sharedWorkspace().absolutePathForAppBundleWithIdentifier(Constants.iTermBundlePath)
    let defaultTerminalPath = NSWorkspace.sharedWorkspace().absolutePathForAppBundleWithIdentifier(Constants.defaultTerminalBundlePath)


    override func awakeFromNib() {
        self.fillUpDefaultTerminalSeletion()
    }

    private func fillUpDefaultTerminalSeletion() {
        var iTermMenu: NSMenuItem? = nil
        var defaultTerminalMenu: NSMenuItem? = nil

        if let iTermPath = self.iTermPath {
            let iTermIcon = NSWorkspace.sharedWorkspace().iconForFile(iTermPath)
            let iTermBundle = NSBundle(path: iTermPath)!  // must exist!
            let iTermAppName = iTermBundle.objectForInfoDictionaryKey(kCFBundleExecutableKey as String) as! String

            iTermMenu = NSMenuItem(title: iTermAppName, action: #selector(selectDefaultIterm(_:)), keyEquivalent: iTermAppName)
            iTermMenu!.image = iTermIcon
            self.defaultTerminalMenu.addItem(iTermMenu!)
        }

        if let defaultTerminalPath = self.defaultTerminalPath {
            let defaultTerminalIcon = NSWorkspace.sharedWorkspace().iconForFile(defaultTerminalPath)
            let defaultTerminalBundle = NSBundle(path: defaultTerminalPath)!  // must exist!
            let defaultTerminalAppName = defaultTerminalBundle.objectForInfoDictionaryKey(kCFBundleExecutableKey as String) as! String

            defaultTerminalMenu = NSMenuItem(
                title: defaultTerminalAppName,
                action: #selector(selectDefaultdefaultTerminal(_:)),
                keyEquivalent: defaultTerminalAppName
            )

            defaultTerminalMenu!.image = defaultTerminalIcon
            self.defaultTerminalMenu.addItem(defaultTerminalMenu!)
        }

        let userDefaultTerminal = NSUserDefaults.standardUserDefaults().valueForKey(Constants.userDefaultTerminalKey) as! String?
        if let userDefaultTerminal = userDefaultTerminal {
            switch userDefaultTerminal {
                case Constants.iTermValue:
                    if let iTermMenu = iTermMenu {
                        let iTermIndex = self.defaultTerminalMenu.indexOfItem(iTermMenu)
                        self.selectDefaultTerminalMenu(iTermIndex)
                    }
                case Constants.defaultTerminalValue:
                    if let defaultTerminalMenu = defaultTerminalMenu {
                        let defaulteTerminalIndex = self.defaultTerminalMenu.indexOfItem(defaultTerminalMenu)
                        self.selectDefaultTerminalMenu(defaulteTerminalIndex)
                        break
                    }
                default: break
            }
        } else {
            if iTermMenu != nil {
                self.selectDefaultIterm(nil)
            }
            else if defaultTerminalMenu != nil {
                self.selectDefaultdefaultTerminal(nil)
            }
        }
    }

    func selectDefaultIterm(_: AnyObject?) {
        NSUserDefaults.standardUserDefaults().setValue(Constants.iTermValue, forKey: Constants.userDefaultTerminalKey)

    }

    func selectDefaultdefaultTerminal(_: AnyObject?) {
        NSUserDefaults.standardUserDefaults().setValue(Constants.defaultTerminalValue, forKey: Constants.userDefaultTerminalKey)
    }

    func selectDefaultTerminalMenu(index: Int) {
        self.defaultTerminalMenu.performActionForItemAtIndex(index)
    }
}
