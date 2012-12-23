//
//  TwitterConnection.h
//  AFRequestSample
//
//  Created by onegray on 12/22/12.
//  Copyright (c) 2012 onegray. All rights reserved.
//

#import "AFConnection.h"

@interface TwitterConnection : AFConnection

+(TwitterConnection*) sharedConnection;

+(void) performRequest:(AFRequest*)request;

@end
