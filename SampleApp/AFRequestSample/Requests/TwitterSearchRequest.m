//
//  TwitterSearchRequest.m
//  AFRequestSample
//
//  Created by onegray on 12/22/12.
//  Copyright (c) 2012 onegray. All rights reserved.
//

#import "TwitterSearchRequest.h"
#import "AFConnection.h"

@implementation TwitterSearchRequest
@dynamic completionHandler;

+(TwitterSearchRequest*) requestWithQuery:(NSString*)aQuery delegate:(id)target {
	return [[self alloc] initWithQuery:aQuery delegate:target];
}

-(id) initWithQuery:(NSString*)aQuery delegate:(id)delegate
{
	self = [super initWithResponseClass:[TwitterSearchResponse class] target:delegate
							   selector:@selector(requestTwitterSearch:didFinishWithResponse:)];
    if(self)
    {
		NSDictionary* params = @{@"q":aQuery};
		
		self.buildRequestOperation = ^AFHTTPRequestOperation*(AFConnection* connection, id onSuccess, id onFailure) {
			NSURLRequest *request = [connection requestWithMethod:@"GET" path:@"/search" parameters:params];
			return [connection HTTPRequestOperationWithRequest:request success:onSuccess failure:onFailure];
		};
    }
    return self;
}

-(void) dealloc
{
	NSLog(@"%@ dealloc", self);
}

@end



@implementation TwitterSearchResponse
@synthesize searchResults;

-(id) initWithResponseObject:(id)responseObject statusCode:(int)statusCode
{
	if(self=[super initWithResponseObject:responseObject statusCode:statusCode])
	{
        NSDictionary* resultDictionary = responseObject;
        NSArray* resultArray = [resultDictionary objectForKey:@"results"];
        NSMutableArray* results = [NSMutableArray arrayWithCapacity:[resultArray count]];
        for(NSDictionary* itemDict in resultArray)
        {
            NSString* itemStr = [itemDict objectForKey:@"text"];
            if(itemStr)
            {
                [results addObject:itemStr];
            }
        }
        self.searchResults = results;
	}
	return self;
}

-(void) dealloc
{
	NSLog(@"%@ dealloc", self);
}

@end

