//
//  AFRequest.m
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

#import "AFRequest.h"
#import "AFResponse.h"
#import "AFConnection.h"
#import "AFHTTPRequestOperation.h"

#import <objc/objc-runtime.h>

@interface AFHTTPRequestOperation(owner)
@property (nonatomic, assign) AFRequest* ownerRequest;
@end

@implementation AFHTTPRequestOperation(owner)
static char OWNER_KEY;

-(AFRequest*) ownerRequest {
	return objc_getAssociatedObject(self, &OWNER_KEY);
}

-(void) setOwnerRequest:(AFRequest*)owner {
	objc_setAssociatedObject(self, &OWNER_KEY, owner, OBJC_ASSOCIATION_ASSIGN);
}
@end

@interface AFRequest()
{
	BOOL _cancelled;
	Class _responseClass;
}
@property (nonatomic, copy) void (^completionHandler)(AFRequest* request, AFResponse* response);

@end

@implementation AFRequest

-(id) initWithResponseClass:(Class)responseClass target:(id)target selector:(SEL)selector
{
	self = [super init];
	if(self) {
		self.target = target;
		[self registerResponseClass:responseClass];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		__weak id weakTarget = target;
		[self setCompletionHandler:^(AFRequest *request, AFResponse *response) {
			if([weakTarget respondsToSelector:selector]) {
				NSMethodSignature* ms = [weakTarget methodSignatureForSelector:selector];
				int argc = [ms numberOfArguments]-2;
				if(argc==2) {
					[weakTarget performSelector:selector withObject:request withObject:response];
				} else if(argc==1) {
					[weakTarget performSelector:selector withObject:response];
				} else if(argc==0) {
					[weakTarget performSelector:selector];
				} 
			}
		}];
#pragma clang diagnostic pop
		
	}
	return self;
}

-(void) registerResponseClass:(Class)responseClass
{
	NSAssert([responseClass isSubclassOfClass:[AFResponse class]], @"responseClass must be derived from AFResponse");
	_responseClass = responseClass;
}

-(void) cancel
{
	[_operation cancel];
	_cancelled = YES;
}

-(BOOL) isCancelled
{
	return _cancelled || [_operation isCancelled];
}

-(int) responseStatusCode
{
	return _operation.response.statusCode;
}

-(void) setOperation:(AFHTTPRequestOperation*)op
{
	if(_operation!=op) {
		_operation.ownerRequest = nil;
		_operation = op;
		_operation.ownerRequest = self;
	}
}

-(void) performOnConnection:(AFConnection*)connection
					success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))onSuccess
					failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onFailure
{
	_retryCount++;
	self.operation = _buildRequestOperation(connection, onSuccess, onFailure);
	_cancelled = _operation.isCancelled;
	[connection enqueueHTTPRequestOperation:_operation];
}


- (void) requestDidFinishWithResponseObject:(id)parsedResult
{
	if(![self isCancelled]) {
		AFResponse* response = [_responseClass responseWithResponseObject:parsedResult statusCode:self.responseStatusCode];
		if(_completionHandler) {
			_completionHandler(self, response);
		}
	}
}

- (void) requestDidFailWithError:(NSError*)error
{
	if(![self isCancelled]) {
		AFResponse* response = [_responseClass responseWithError:error statusCode:self.responseStatusCode];
		if(_completionHandler) {
			_completionHandler(self, response);
		}
	}
}


@end























