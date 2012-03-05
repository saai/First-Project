//
//  MyInternetConnector.m
//  ASAP
//
//  Created by Sha Yan on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyInternetConnector.h"
#import "MyURLConnection.h"
@implementation MyInternetConnector

@synthesize target,allConnections;



-(BOOL) startConnectionWithURLString: (NSString *) urlStr
{
    if (urlStr == nil) 
    {
        return NO;
    }
    NSURLRequest *myRequest = [self generateRequestWithURL:urlStr];
    NSURLConnection *myConnection = [[[NSURLConnection alloc] initWithRequest:myRequest delegate:self startImmediately:NO] autorelease];
    [myConnection start];
    return YES;
}

-(BOOL) startConnectionWithMethod: (NSString *)methodName options:(NSDictionary *) options
{
    if (methodName == nil) 
    {
        return NO;
    }
    NSURLRequest *myRequest = [self generateRequestWithMethod:methodName options:options];
    NSURLConnection *myConnection = [[[NSURLConnection alloc] initWithRequest:myRequest delegate:self startImmediately:NO] autorelease];
    [myConnection start];
    return YES;
    
}
-(void) removeTargetFromConnector
{
    target = nil;
    [allConnections removeAllObjects];
}

-(void) assignTargetToConnector:(id) newTarget
{
    
}
-(NSURLRequest *)generateRequestWithURL : (NSString *)urlStr
{
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    return  myRequest;
    
}
-(NSURLRequest *)generateRequestWithMethod:(NSString *) methodName options:(NSDictionary *) options
{
    /* To do list*/
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"www.google.com.hk"]];
    return  myRequest;
}



-(id)init
{
    if (self = [super init]) 
    {
        self.allConnections = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

-(void)dealloc
{
    self.allConnections = nil;
    self.target = nil;
    [super dealloc];
}

@end
