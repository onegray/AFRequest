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

+(___FILEBASENAME___Request*) requestWith___VARIABLE_param1___:(NSString*)a___VARIABLE_param1___ delegate:(id<___FILEBASENAME___RequestDelegate>)delegate {
    return [[___FILEBASENAME___Request alloc] initWith___VARIABLE_param1___:a___VARIABLE_param1___ delegate:delegate];
}

-(id) initWith___VARIABLE_param1___:(NSString*)a___VARIABLE_param1___ delegate:(id<___FILEBASENAME___RequestDelegate>)delegate
{
	self = [super initWithResponseClass:[___FILEBASENAME___Response class] target:delegate
							   selector:@selector(request___FILEBASENAME___:didFinishWithResponse:)];
	if(self)
	{
		NSDictionary* params = @{@"<#___VARIABLE_param1___#>":a___VARIABLE_param1___};
		
		self.buildRequestOperation = ^AFHTTPRequestOperation*(AFConnection* connection, id onSuccess, id onFailure) {
			NSURLRequest *request = [connection requestWithMethod:@"<#GET#>" path:@"<#/___FILEBASENAMEASIDENTIFIER___#>" parameters:params];
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

