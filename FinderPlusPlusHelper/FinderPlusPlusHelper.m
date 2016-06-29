//
//  FinderPlusPlusHelper.m
//  FinderPlusPlusHelper
//
//  Created by Luavis on 6/28/16.
//  Copyright © 2016 Luavis. All rights reserved.
//

#import "FinderPlusPlusHelper.h"
#import "FinderPlusPlusHelper-Swift.h"


@implementation FinderPlusPlusHelper

- (void)runScript:(NSString *)command params:(NSArray<NSString *> *)arguments {
    [Utils shell:command arguments:arguments];
}

- (void)openTerminal:(NSURL *)url terminalType:(TerminalType)terminalType {
    NSString *path = nil;
    if(url.isFileURL && (path = url.path)) {
        NSString *command = [NSString stringWithFormat:@"cd %@", path];
        switch(terminalType) {
            case TerminalTypeOSXDefault:
                [Utils openInTerminal:command];
            case TerminalTypeIterm:
                [Utils openInITerm:command];
            default:
                break;
        }
    }
}

- (void)createNewFile:(NSURL *)path fileName:(NSString *)filename {
    [Utils createFile:path filename:filename];
}

@end
