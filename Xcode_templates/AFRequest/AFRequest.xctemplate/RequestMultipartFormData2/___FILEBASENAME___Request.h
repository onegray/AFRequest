//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFRequest.h"
#import "AFResponse.h"


@class ___FILEBASENAME___Request, ___FILEBASENAME___Response;
@protocol ___FILEBASENAME___RequestDelegate <NSObject>
@optional
-(void) request___FILEBASENAME___:(___FILEBASENAME___Request*)request didFinishWithResponse:(___FILEBASENAME___Response*)response;
@end


@interface ___FILEBASENAME___Request : AFRequest
-(id) initWith___VARIABLE_param1___:(NSString*)a___VARIABLE_param1___ and___VARIABLE_param2___:(NSString*)a___VARIABLE_param2___ delegate:(id<___FILEBASENAME___RequestDelegate>)aDelegate;
+(___FILEBASENAME___Request*) requestWith___VARIABLE_param1___:(NSString*)a___VARIABLE_param1___ and___VARIABLE_param2___:(NSString*)a___VARIABLE_param2___ delegate:(id<___FILEBASENAME___RequestDelegate>)delegate;
@property (nonatomic, copy) void (^completionHandler)(___FILEBASENAME___Request* request, ___FILEBASENAME___Response* response);
@end


@interface ___FILEBASENAME___Response : AFResponse
-(id) initWithResponseObject:(id)responseObject statusCode:(int)statusCode;
@end

