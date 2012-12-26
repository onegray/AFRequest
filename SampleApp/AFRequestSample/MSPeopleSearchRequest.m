//
//  MSPeopleSearchRequest.m
//  AFRequestSample
//
//  Created by onegray on 12/26/12.
//  Copyright (c) 2012 onegray. All rights reserved.
//

#import "MSPeopleSearchRequest.h"
#import "AFConnection.h"

@implementation MSPeopleSearchRequest
@dynamic completionHandler;

+(MSPeopleSearchRequest*) requestWithSearchTerms:(NSString*)aSearchTerms delegate:(id<MSPeopleSearchRequestDelegate>)delegate {
    return [[MSPeopleSearchRequest alloc] initWithSearchTerms:aSearchTerms delegate:delegate];
}

-(id) initWithSearchTerms:(NSString*)aSearchTerms delegate:(id<MSPeopleSearchRequestDelegate>)delegate
{
	self = [super initWithResponseClass:[MSPeopleSearchResponse class] target:delegate
							   selector:@selector(requestMSPeopleSearch:didFinishWithResponse:)];
	if(self)
	{
		NSDictionary* params = @{@"searchTerms":aSearchTerms};
		
		self.buildRequestOperation = ^AFHTTPRequestOperation*(AFConnection* connection, id onSuccess, id onFailure) {
			NSURLRequest *request = [connection requestWithMethod:@"GET" path:@"/opensearch/people" parameters:params];
			return [connection HTTPRequestOperationWithRequest:request success:onSuccess failure:onFailure];
		};
	}
	return self;
}

@end



@implementation MSPeopleSearchResponse

-(id) initWithResponseObject:(id)responseObject statusCode:(int)statusCode
{
	if(self=[super initWithResponseObject:responseObject statusCode:statusCode]) {
        NSArray* resultArray = [responseObject objectForKey:@"entry"];
        NSMutableArray* results = [NSMutableArray arrayWithCapacity:[resultArray count]];
        for(NSDictionary* itemDict in resultArray) {
            NSString* itemStr = [itemDict objectForKey:@"displayName"];
            if(itemStr) {
                [results addObject:itemStr];
            }
        }
        self.searchResults = results;
	}
	return self;
}

@end

