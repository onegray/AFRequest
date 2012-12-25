//
//  AFResponse.m
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

#import "AFResponse.h"

static NSString *const kAFErrorDomain = @"com.afrequest.error";
static const int kAFErrorCode = 101;

@implementation AFResponse

-(id) initWithResponseObject:(id)responseObject statusCode:(int)statusCode
{
	if(self=[super init]) {
		_success = YES;
		_statusCode = statusCode;
	}
	return self;
}

-(id) initWithError:(NSError*)anError statusCode:(int)statusCode
{
	if(self=[super init]) {
		_success = NO;
		_statusCode = statusCode;
		_error = anError;
	}
	return self;
}

+(id) responseWithResponseObject:(id)responseObject statusCode:(int)statusCode
{
	return [[self alloc] initWithResponseObject:responseObject statusCode:statusCode];
}

+(id) responseWithError:(NSError*)anError statusCode:(int)statusCode
{
	return [[self alloc] initWithError:anError statusCode:statusCode];
}

+(id) responseWithCustomErrorMessage:(NSString*)errorMsg statusCode:(int)statusCode
{
	NSDictionary* errorInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
	NSError* anError = [NSError errorWithDomain:kAFErrorDomain code:kAFErrorCode userInfo:errorInfo];
	AFResponse* response = [[self alloc] initWithError:anError statusCode:statusCode];
	return response;
}

-(void) setErrorResponseWithMessage:(NSString*)errorMsg
{
	NSDictionary* errorInfo = [NSDictionary dictionaryWithObject:errorMsg forKey:NSLocalizedDescriptionKey];
	_error = [NSError errorWithDomain:kAFErrorDomain code:kAFErrorCode userInfo:errorInfo];
	_success = NO;
}

@end
