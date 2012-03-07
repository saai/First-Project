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

#pragma mark - Override Methods
-(id)init
{
    if (self = [super init]) 
    {
        self.allConnections = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return self;
}

-(void)dealloc
{
    self.allConnections = nil;
    self.target = nil;
    [super dealloc];
}

#pragma mark - Custom Methods
-(void) assignTargetToConnector:(id) newTarget
{
    self.target = newTarget;
    
}
-(void) removeTargetFromConnector
{
    target = nil;
    [allConnections removeAllObjects];
}


-(BOOL) startConnectionWithURLString: (NSString *) urlStr callBackMethod:(SEL) callBackMethod
{
    if (urlStr == nil) 
    {
        return NO;
    }

    return YES;
}

-(BOOL) startConnectionWithMethod: (NSString *)methodName options:(NSDictionary *) options  callBackMethod:(SEL) callBackMethod
{
    if (methodName == nil) 
    {
        return NO;
    }
    NSURLRequest *request = [self generateRequestWithMethod:methodName options:nil];
    NSString *connectionKey = methodName;
    MyURLConnection *anConnection = [[MyURLConnection alloc] init];
    anConnection.delegate = self;
    [allConnections  setValue:anConnection forKey:connectionKey];
    [anConnection startConnectionWithKey:connectionKey request:request callBackMethod:callBackMethod];
    [anConnection release];
    return YES;
    
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

-(BOOL) cancelConnection:(NSString *) connectionKey
{
    return YES;
}
-(BOOL) cancelAllConnections
{
    return YES;
}


#pragma mark - MyURLConnectionDelegate

-(void) connectionDidEndDownload:(NSData *) downloadedData connectionKey:(NSString*) connectionKey
{
    /*To Do List*/
    // return the data to the target method according to the connectionKey; 
    
}
-(void)connectionDidFailWithError:(NSError *)error connectionKey:(NSString *)connectionKey callBackMethod:(SEL)callBackMethod
{

}


@end
