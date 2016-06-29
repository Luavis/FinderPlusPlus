//
//  Utils.swift
//  FinderPlusPlus
//
//  Created by Luavis on 6/29/16.
//  Copyright © 2016 Luavis. All rights reserved.
//

import Foundation

@objc class Utils: NSObject {

    static func shell(launchPath: String, arguments: [String]) -> String
    {
        let task = NSTask()
        task.launchPath = launchPath
        task.arguments = arguments

        let pipe = NSPipe()
        task.standardOutput = pipe
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: NSUTF8StringEncoding)!
        if output.characters.count > 0 {
            return output.substringToIndex(output.endIndex.advancedBy(-1))

        }
        return output
    }

    static func bash(command: String, arguments: [String]) -> String {
        let whichPathForCommand = shell("/bin/bash", arguments: [ "-l", "-c", "which \(command)" ])
        return shell(whichPathForCommand, arguments: arguments)
    }

    static func openInTerminal(command: String) -> NSDictionary? {
        let openTerminalScriptSource =
            "tell Application \"Terminal\" \n" +
                "activate \n" +
                "do script \"cd " + command + "\" \n" +
        "end tell"
        print(openTerminalScriptSource)

        let openTerminalScript = NSAppleScript.init(source: openTerminalScriptSource)
        var error:NSDictionary? = nil
        openTerminalScript?.executeAndReturnError(&error)

        return error
    }

    static func openInITerm(command: String) -> NSDictionary? {
        let openiTermScriptSource =
            "tell application \"iTerm\"\n" +
                "activate\n" +
                "set newWindow to (create window with default profile)\n" +
                "tell current session of newWindow\n" +
                "write text \"" + command + "\"\n" +
                "end tell\n" +
        "end tell"

        let openiTermScript = NSAppleScript.init(source: openiTermScriptSource)
        var error:NSDictionary? = nil
        openiTermScript?.executeAndReturnError(&error)
        
        return error
    }

    static func createFile(pathUrl: NSURL, filename: String) {

        if(pathUrl.fileURL) {
            let destUrl = pathUrl.URLByAppendingPathComponent(filename)
            try! "".writeToURL(destUrl, atomically: true, encoding: NSUTF8StringEncoding)
        }
    }

}