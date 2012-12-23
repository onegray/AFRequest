//
//  AFConnection.m
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

#import "AFConnection.h"
#import "AFRequest.h"
#import "AFHTTPRequestOperation.h"

#ifndef AFlog
#define AFLog NSLog
#endif

@interface AFRequest(private)
-(void) performOnConnection:(AFConnection*)connection
					success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
					failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end

@interface AFHTTPRequestOperation(owner)
@property (nonatomic, assign) AFRequest* ownerRequest;
@end

@implementation AFConnection

- (void) performRequest:(AFRequest*)request
{
	[request performOnConnection:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
		
		if(_printLogs) {
			AFLog(@"%@ finished with response: %d \n%@", operation.request, request.responseStatusCode,
				  responseObject ? responseObject : operation.responseString);
			AFLog(@"\n  -----------------------------------------  \n\n");
		}
		
		BOOL shouldComplete = ![request isCancelled];
		if(shouldComplete && [_delegate respondsToSelector:@selector(connection:shouldCompleteRequest:withResponseObject:)]) {
			shouldComplete = [_delegate connection:self shouldCompleteRequest:request withResponseObject:responseObject];
		}
		
		if(shouldComplete) {
			AFResponse* response = nil;
			if([_delegate respondsToSelector:@selector(connection:handleRequest:withResponseObject:)]) {
				response = [_delegate connection:self handleRequest:request withResponseObject:responseObject];
			}
			
			if(response) {
				if(request.completionHandler) {
					request.completionHandler(request, response);
				}
			} else {
				[request requestDidFinishWithResponseObject:responseObject];
			}
		}
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
		if(_printLogs) {
			AFLog(@"%@ failed with error: %d - %@", operation.request, request.responseStatusCode, [error localizedDescription]);
			AFLog(@"Response data: %@", operation.responseString);
			AFLog(@"\n  -----------------------------------------  \n\n");
		}
		
		BOOL shouldComplete = ![request isCancelled];
		if(shouldComplete && [_delegate respondsToSelector:@selector(connection:shouldCompleteRequest:withError:)]) {
			shouldComplete = [_delegate connection:self shouldCompleteRequest:request withError:error];
		}
		
		if(shouldComplete) {
			AFResponse* response = nil;
			if([_delegate respondsToSelector:@selector(connection:handleRequest:withError:)]) {
				response = [_delegate connection:self handleRequest:request withError:error];
			}
			
			if(response) {
				if(request.completionHandler) {
					request.completionHandler(request, response);
				}
			} else {
				[request requestDidFailWithError:error];
			}
		}
		
	}];
	
	if(_printLogs) {
		AFLog(@"\n\n  =========================================  ");
		AFLog(@"Starting %@ ", request);
	}
}

- (void)cancelRequestsForTarget:(id)target
{
    for (AFHTTPRequestOperation *op in [self.operationQueue operations]) {
		if(![op isCancelled]) {
			if(op.ownerRequest.target == target) {
				[op.ownerRequest cancel];
			}
		}
	}
}

@end
