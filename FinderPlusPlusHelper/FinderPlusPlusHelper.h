//
//  FinderPlusPlusHelper.h
//  FinderPlusPlusHelper
//
//  Created by Luavis on 6/28/16.
//  Copyright © 2016 Luavis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FinderPlusPlusHelperProtocol.h"

// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
@interface FinderPlusPlusHelper : NSObject <FinderPlusPlusHelperProtocol>
@end
