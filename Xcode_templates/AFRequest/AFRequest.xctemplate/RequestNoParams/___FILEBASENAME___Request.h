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
-(id) initWithDelegate:(id<___FILEBASENAME___RequestDelegate>)aDelegate;
+(___FILEBASENAME___Request*) requestWithDelegate:(id<___FILEBASENAME___RequestDelegate>)aDelegate;
@property (nonatomic, copy) void (^completionHandler)(___FILEBASENAME___Request* request, ___FILEBASENAME___Response* response);
@end


@interface ___FILEBASENAME___Response : AFResponse
-(id) initWithResponseObject:(id)responseObject statusCode:(int)statusCode;
@end

