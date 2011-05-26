//
//  VailUtility.m
//  VailProject
//
//  Created by Jeongjin on 5/5/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "VailUtility.h"
#import "ASIHTTPRequest.h"

@implementation VailUtility


+ (BOOL)sendHTTP:(NSString*) url{
    NSLog(@"request url: %@",url);
    NSURL *nurl = [NSURL URLWithString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:nurl];
    [request startSynchronous];
    return true;
}
@end
