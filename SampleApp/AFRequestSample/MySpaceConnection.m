//
//  MySpaceConnection.m
//  AFRequestSample
//
//  Created by onegray on 12/26/12.
//  Copyright (c) 2012 onegray. All rights reserved.
//

#import "MySpaceConnection.h"
#import "AFJSONRequestOperation.h"

static NSString* kMySpaceHost = @"http://api.myspace.com";

@implementation MySpaceConnection

+(MySpaceConnection*) sharedConnection
{
	static MySpaceConnection* instance = nil;
	if(!instance) {
		instance = [[MySpaceConnection alloc] initWithBaseURL:[NSURL URLWithString:kMySpaceHost]];
	}
	return instance;
}

+(void) performRequest:(AFRequest*)request
{
	[[self sharedConnection] performRequest:request];
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
		
		[self registerHTTPOperationClass:[AFJSONRequestOperation class]];
		
		[self setDefaultHeader:@"Accept" value:@"application/json"];
		[self setDefaultHeader:@"Content-Type" value:@"application/json"];
		
		self.printLogs = YES;
    }
    
    return self;
}


@end
