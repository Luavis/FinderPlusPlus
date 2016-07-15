//
//  SettingWindow.swift
//  FinderPlusPlus
//
//  Created by Luavis on 6/30/16.
//  Copyright © 2016 Luavis. All rights reserved.
//

import Cocoa


class SettingWindow : NSWindow, NSTextFieldDelegate {

    @IBOutlet weak var defaultTerminalMenu: NSMenu!
    @IBOutlet weak var newFileNameTextField: NSTextField!
    @IBOutlet weak var newFileCheckBox: NSButton!
    @IBOutlet weak var copyFilePathCheckBox: NSButton!
    @IBOutlet weak var openInTerminalCheckBox: NSButton!

    let iTermPath = NSWorkspace.sharedWorkspace().absolutePathForAppBundleWithIdentifier(Constants.iTermBundlePath)
    let defaultTerminalPath = NSWorkspace.sharedWorkspace().absolutePathForAppBundleWithIdentifier(Constants.defaultTerminalBundlePath)
    let userDefaults = NSUserDefaults(suiteName: "com.luavis")!


    override func awakeFromNib() {
        self.fillUpDefaultTerminalSeletion()
        self.initFileNameField()
        self.fillUpUserMenu()
    }

    func selectDefaultIterm(_: AnyObject?) {
        userDefaults.setValue(Constants.iTermValue, forKey: Constants.userDefaultTerminalKey)
        userDefaults.synchronize()
    }

    func selectDefaultdefaultTerminal(_: AnyObject?) {
        userDefaults.setValue(Constants.defaultTerminalValue, forKey: Constants.userDefaultTerminalKey)
        userDefaults.synchronize()
    }

    func toggleNewFileMenu(sender: NSButton) {
        let state = (sender.state == NSOnState)
        userDefaults.setBool(state, forKey: Constants.newFileMenuToggleKey)
        userDefaults.synchronize()
    }

    func toggleOpenInTerminal(sender: NSButton) {
        let state = (sender.state == NSOnState)
        userDefaults.setBool(state, forKey: Constants.openInTerminalToggleKey)
        userDefaults.synchronize()
    }

    func toggleCopyFilePath(sender: NSButton) {
        let state = (sender.state == NSOnState)
        userDefaults.setBool(state, forKey: Constants.copyPathToggleKey)
        userDefaults.synchronize()
    }

    override func controlTextDidChange(obj: NSNotification) {
        if obj.object === self.newFileNameTextField {
            userDefaults.setValue(self.newFileNameTextField.stringValue, forKey: Constants.userUntitledFileNameKey)
        }
    }

    private func fillUpUserMenu() {
        let newFileMenuToggle =
            userDefaults.boolForKey(Constants.newFileMenuToggleKey) ? NSOnState : NSOffState
        let openInTerminalToggle =
            userDefaults.boolForKey(Constants.openInTerminalToggleKey) ? NSOnState : NSOffState
        let copyPathToggle =
            userDefaults.boolForKey(Constants.copyPathToggleKey) ? NSOnState : NSOffState

        self.newFileCheckBox.state = newFileMenuToggle
        self.openInTerminalCheckBox.state = openInTerminalToggle
        self.copyFilePathCheckBox.state = copyPathToggle

        self.newFileCheckBox.target = self
        self.newFileCheckBox.action = #selector(toggleNewFileMenu(_:))

        self.openInTerminalCheckBox.target = self
        self.openInTerminalCheckBox.action = #selector(toggleOpenInTerminal(_:))

        self.copyFilePathCheckBox.target = self
        self.copyFilePathCheckBox.action = #selector(toggleCopyFilePath(_:))
    }

    private func initFileNameField() {
        self.newFileNameTextField.delegate = self
        self.fillUpNewFileNameField()
    }

    private func fillUpNewFileNameField() {
        var untitledFileName = NSLocalizedString("untitled file", comment: "untitled file")
        let userUntitledFileName = userDefaults.valueForKey(Constants.userUntitledFileNameKey) as! String?
        if let userUntitledFileName = userUntitledFileName {
            untitledFileName = userUntitledFileName
        }

        self.newFileNameTextField.stringValue = untitledFileName
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

        let userDefaultTerminal = userDefaults.valueForKey(Constants.userDefaultTerminalKey) as! String?
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
    
    private func selectDefaultTerminalMenu(index: Int) {
        self.defaultTerminalMenu.performActionForItemAtIndex(index)
    }
}
