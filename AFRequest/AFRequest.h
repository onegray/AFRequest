//
//  AFRequest.h
//
//  Created by Sergey Nikitenko on 12/22/12.
//  Copyright 2012 Sergey Nikitenko. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

@class AFConnection, AFRequest, AFResponse;


@interface AFRequest : NSObject

// initializing: responseClass is required, target and selector are optional.
-(id) initWithResponseClass:(Class)responseClass target:(id)target selector:(SEL)selector;
-(void) registerResponseClass:(Class)responseClass;
@property (nonatomic, weak) id target;

// @property completionHandler is optional, default inplementation uses "target + selector" pair.
-(void) setCompletionHandler:(void (^)(AFRequest* request, AFResponse* response)) completionHandler;
-(void (^)(AFRequest* request, AFResponse* response)) completionHandler;

// @property buildRequestOperation is required.
@property (nonatomic, copy) AFHTTPRequestOperation* (^buildRequestOperation)(AFConnection* connection, id onSuccess, id onFailure);

@property (nonatomic, readonly) AFHTTPRequestOperation* operation;
@property (nonatomic, readonly) int responseStatusCode;
@property (nonatomic, readonly) BOOL isCancelled;
@property (nonatomic, readonly) int retryCount;

// After cancelling the request, no one completion callback will be called.
- (void) cancel;

// Completion handlers. Can be overloaded in derived classes.
- (void) requestDidFinishWithResponseObject:(id)parsedResult;
- (void) requestDidFailWithError:(NSError*)error;

@end


@interface AFHTTPRequestOperation(extentions)
@property (atomic, strong) AFRequest* ownerRequest;
@property (atomic, strong) NSIndexSet* acceptableStatusCodes;
@property (atomic, strong) NSSet* acceptableContentTypes;
@end
