//
//  MySpaceConnection.h
//  AFRequestSample
//
//  Created by onegray on 12/26/12.
//  Copyright (c) 2012 onegray. All rights reserved.
//

#import "AFConnection.h"

@interface MySpaceConnection : AFConnection

+(MySpaceConnection*) sharedConnection;

+(void) performRequest:(AFRequest*)request;

@end
