//
//  TwitterConnection.m
//  AFRequestSample
//
//  Created by onegray on 12/22/12.
//  Copyright (c) 2012 onegray. All rights reserved.
//

#import "TwitterConnection.h"
#import "AFJSONRequestOperation.h"

static NSString* kTwiterHost = @"http://search.twitter.com";

@implementation TwitterConnection

+(TwitterConnection*) sharedConnection
{
	static TwitterConnection* instance = nil;
	if(!instance) {
		instance = [[TwitterConnection alloc] initWithBaseURL:[NSURL URLWithString:kTwiterHost]];
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
		
		self.acceptableStatusCodes = [NSIndexSet indexSetWithIndex:200];
		self.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
		
		[self setDefaultHeader:@"Accept" value:@"application/json"];
		[self setDefaultHeader:@"Content-Type" value:@"application/json"];
		
		self.printLogs = YES;
    }
    
    return self;
}


@end
