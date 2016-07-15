//
//  AppDelegate.swift
//  FinderPlusPlus
//
//  Created by Luavis on 6/23/16.
//  Copyright © 2016 Luavis. All rights reserved.
//

import Cocoa


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var preferencesWindowController:NSWindowController?

    // MARK: Delegates

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        self.initPreferencesWindow()
    }

    func applicationDidBecomeActive(notification: NSNotification) {
        self.reopenPreferencesWindow()
    }

    func applicationDidResignActive(notification: NSNotification) {
        self.hidePreferencesWindow()
    }

    // MARK: - Actions

    @IBAction func onClickPreferences(sender: AnyObject) {
        reopenPreferencesWindow()
    }

    // MARK: - Private functions

    private func initPreferencesWindow() {
        self.preferencesWindowController = NSWindowController(windowNibName: "SettingWindow")
        self.preferencesWindowController!.showWindow(self)
        self.preferencesWindowController!.window?.makeMainWindow()
    }

    private func reopenPreferencesWindow() {
        if self.preferencesWindowController!.windowLoaded {
            self.preferencesWindowController!.window?.makeKeyAndOrderFront(self)
        }
        else {
            self.preferencesWindowController!.showWindow(self)
            self.preferencesWindowController!.window?.makeMainWindow()
        }
    }

    private func hidePreferencesWindow() {
        self.preferencesWindowController!.window?.orderOut(nil)
    }
}
