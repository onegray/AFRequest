//
//  TwitterSearchRequest.h
//  AFRequestSample
//
//  Created by onegray on 12/22/12.
//  Copyright (c) 2012 onegray. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFRequest.h"
#import "AFResponse.h"

@class TwitterSearchRequest, TwitterSearchResponse;
@protocol TwitterSearchRequestDelegate <NSObject>
@optional
-(void) requestTwitterSearch:(TwitterSearchRequest*)request didFinishWithResponse:(TwitterSearchResponse*)response;
@end


@interface TwitterSearchRequest : AFRequest
-(id) initWithQuery:(NSString*)aQuery delegate:(id)target;
+(TwitterSearchRequest*) requestWithQuery:(NSString*)aQuery delegate:(id)target;
@property (nonatomic, copy) void (^completionHandler)(TwitterSearchRequest* request, TwitterSearchResponse* response);
@end



@interface TwitterSearchResponse : AFResponse
-(id) initWithResponseObject:(id)responseObject statusCode:(int)statusCode;

@property (nonatomic, retain) NSArray* searchResults;

@end
