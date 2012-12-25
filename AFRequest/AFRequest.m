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


@interface AFRequest()
{
	BOOL _cancelled;
	Class _responseClass;
	__weak AFHTTPRequestOperation* _operation;
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
	NSAssert(_operation!=nil, @"Request operation has been finished, check -[AFResponse statusCode] instead");
	return _operation.response.statusCode;
}

-(void) setOperation:(AFHTTPRequestOperation*)op
{
	if(_operation!=op) {
		op.ownerRequest = self;
		_operation.ownerRequest = nil;
		_operation = op;
	}
}

-(void) performOnConnection:(AFConnection*)connection
					success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))onSuccess
					failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onFailure
{
	_retryCount++;
	AFHTTPRequestOperation* strongOp = _buildRequestOperation(connection, onSuccess, onFailure);
	if(!strongOp.acceptableStatusCodes && connection.acceptableStatusCodes) {
		strongOp.acceptableStatusCodes = connection.acceptableStatusCodes;
	}
	if(!strongOp.acceptableContentTypes && connection.acceptableContentTypes) {
		strongOp.acceptableContentTypes = connection.acceptableContentTypes;
	}
	[strongOp performSelector:@selector(overloadExtentions)];
	[self setOperation:strongOp];
	_cancelled = strongOp.isCancelled;
	[connection enqueueHTTPRequestOperation:strongOp];
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



#import <objc/objc-runtime.h>

@implementation AFHTTPRequestOperation(extentions)
static char OWNER_KEY;
static char STATUS_CODES_KEY;
static char CONTENT_TYPES_KEY;

-(AFRequest*) ownerRequest {
	return objc_getAssociatedObject(self, &OWNER_KEY);
}

-(void) setOwnerRequest:(AFRequest*)owner {
	objc_setAssociatedObject(self, &OWNER_KEY, owner, OBJC_ASSOCIATION_RETAIN);
}

-(NSIndexSet*) acceptableStatusCodes {
	return objc_getAssociatedObject(self, &STATUS_CODES_KEY);
}

-(void) setAcceptableStatusCodes:(NSIndexSet*) statusCodes {
	objc_setAssociatedObject(self, &STATUS_CODES_KEY, statusCodes, OBJC_ASSOCIATION_RETAIN);
}

-(NSSet*) acceptableContentTypes {
	return objc_getAssociatedObject(self, &CONTENT_TYPES_KEY);
}

-(void) setAcceptableContentTypes:(NSSet *)contentTypes {
	objc_setAssociatedObject(self, &CONTENT_TYPES_KEY, contentTypes, OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)hasAcceptableStatusCode_overloaded {
	if (!self.response) {
		return NO;
	}
    
	NSIndexSet* acceptableStatusCodes = [self acceptableStatusCodes];
	if(!acceptableStatusCodes) {
		acceptableStatusCodes = [[self class] acceptableStatusCodes];
	}
	
    NSUInteger statusCode = ([self.response isKindOfClass:[NSHTTPURLResponse class]]) ? (NSUInteger)[self.response statusCode] : 200;
    return !acceptableStatusCodes || [acceptableStatusCodes containsIndex:statusCode];
}

- (BOOL)hasAcceptableContentType_overloaded {
    if (!self.response) {
		return NO;
	}
    
	NSSet* acceptableContentTypes = [self acceptableContentTypes];
	if(!acceptableContentTypes) {
		acceptableContentTypes = [[self class] acceptableContentTypes];
	}
	
    // Any HTTP/1.1 message containing an entity-body SHOULD include a Content-Type header field defining the media type of that body. If and only if the media type is not given by a Content-Type field, the recipient MAY attempt to guess the media type via inspection of its content and/or the name extension(s) of the URI used to identify the resource. If the media type remains unknown, the recipient SHOULD treat it as type "application/octet-stream".
    // See http://www.w3.org/Protocols/rfc2616/rfc2616-sec7.html
    NSString *contentType = [self.response MIMEType];
    if (!contentType) {
        contentType = @"application/octet-stream";
    }
    
    return !acceptableContentTypes || [acceptableContentTypes containsObject:contentType];
}


-(void) overloadMethod:(SEL)existingMethod withMethod:(SEL)overloadingMethod saveOriginalMethod:(SEL)originalMethod {
	if( class_getInstanceMethod([self class], originalMethod) == NULL ) {
		Method instanceMethod = class_getInstanceMethod([self class], existingMethod);
		class_addMethod([self class], originalMethod, method_getImplementation(instanceMethod), method_getTypeEncoding(instanceMethod));
		Method overloadingInstanceMethod = class_getInstanceMethod([self class], overloadingMethod);
		method_exchangeImplementations(instanceMethod, overloadingInstanceMethod);
	}
}

-(void) overloadExtentions {
	[self overloadMethod:@selector(hasAcceptableStatusCode)
			  withMethod:@selector(hasAcceptableStatusCode_overloaded)
	  saveOriginalMethod:@selector(hasAcceptableStatusCode_original)];

	[self overloadMethod:@selector(hasAcceptableContentType)
			  withMethod:@selector(hasAcceptableContentType_overloaded)
	  saveOriginalMethod:@selector(hasAcceptableContentType_original)];
}

@end


















