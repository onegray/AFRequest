//
//  MSPeopleSearchRequest.h
//  AFRequestSample
//
//  Created by onegray on 12/26/12.
//  Copyright (c) 2012 onegray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFRequest.h"
#import "AFResponse.h"


@class MSPeopleSearchRequest, MSPeopleSearchResponse;
@protocol MSPeopleSearchRequestDelegate <NSObject>
@optional
-(void) requestMSPeopleSearch:(MSPeopleSearchRequest*)request didFinishWithResponse:(MSPeopleSearchResponse*)response;
@end


@interface MSPeopleSearchRequest : AFRequest
-(id) initWithSearchTerms:(NSString*)aSearchTerms delegate:(id<MSPeopleSearchRequestDelegate>)aDelegate;
+(MSPeopleSearchRequest*) requestWithSearchTerms:(NSString*)aSearchTerms delegate:(id<MSPeopleSearchRequestDelegate>)delegate;
@property (nonatomic, copy) void (^completionHandler)(MSPeopleSearchRequest* request, MSPeopleSearchResponse* response);
@end


@interface MSPeopleSearchResponse : AFResponse
-(id) initWithResponseObject:(id)responseObject statusCode:(int)statusCode;
@property (nonatomic, strong) NSArray* searchResults;
@end

