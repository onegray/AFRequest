//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

#import "___FILEBASENAME___Request.h"
#import "AFConnection.h"

@implementation ___FILEBASENAME___Request
@dynamic completionHandler;

+(___FILEBASENAME___Request*) requestWithDelegate:(id<___FILEBASENAME___RequestDelegate>)delegate {
    return [[___FILEBASENAME___Request alloc] initWithDelegate:delegate];
}

-(id) initWithDelegate:(id<___FILEBASENAME___RequestDelegate>)delegate
{
	self = [super initWithResponseClass:[___FILEBASENAME___Response class] target:delegate
							   selector:@selector(request___FILEBASENAME___:didFinishWithResponse:)];
	if(self)
	{
		self.buildRequestOperation = ^AFHTTPRequestOperation*(AFConnection* connection, id onSuccess, id onFailure) {
			NSURLRequest *request = [connection multipartFormRequestWithMethod:@"<#POST#>" path:@"<#/___FILEBASENAMEASIDENTIFIER___#>" parameters:nil
													 constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
														 
														 
													 }];
			return [connection HTTPRequestOperationWithRequest:request success:onSuccess failure:onFailure];
		};
	}
	return self;
}

@end



@implementation ___FILEBASENAME___Response

-(id) initWithResponseObject:(id)responseObject statusCode:(int)statusCode
{
	if(self=[super initWithResponseObject:responseObject statusCode:statusCode])
	{
		
		
	}
	return self;
}

@end

