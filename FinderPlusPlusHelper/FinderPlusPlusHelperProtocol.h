//
//  FinderPlusPlusHelperProtocol.h
//  FinderPlusPlusHelper
//
//  Created by Luavis on 6/28/16.
//  Copyright © 2016 Luavis. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TerminalType) {
    TerminalTypeOSXDefault = 0,
    TerminalTypeIterm = 1,
};


@protocol FinderPlusPlusHelperProtocol

- (void)runScript:(NSString *)command params:(NSArray<NSString *> *)arguments;
- (void)openTerminal:(NSURL *)url terminalType:(TerminalType)terminalType;
- (void)createNewFile:(NSURL *)path fileName:(NSString *)filename
    
@end
