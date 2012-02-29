//
//  MyInternetConnector.m
//  ASAP
//
//  Created by Sha Yan on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyInternetConnector.h"

@implementation MyInternetConnector
@synthesize activeDownloadData, myConnection,myURLStr;


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{

}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownloadData  appendData:data];
}


-(BOOL) startConnectionWithURLString: (NSString *) urlStr
{
    if (urlStr == nil) 
    {
        return NO;
    }
    if ([urlStr compare:self.myURLStr]== NSOrderedSame) 
    {
        [self.myConnection start];
        return  YES;
    }
    self.myURLStr = urlStr;
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.myURLStr]];
    self.myConnection = [[[NSURLConnection alloc] initWithRequest:myRequest delegate:self startImmediately:NO] autorelease];
    [self.myConnection start];
    return YES;
}
-(BOOL) cancelConnection:(NSString *) urlStr
{
    if (urlStr == nil) 
    {
        return NO;
    }
    
    if([urlStr compare:self.myURLStr] == NSOrderedSame)
    {
        [self.myConnection  cancel];
        return YES;
    }
    return NO;
}
-(BOOL) startConnection
{
    self.activeDownloadData = [NSData data];
    if (self.myURLStr != nil) 
    {
        return [self startConnectionWithURLString:self.myURLStr];
    }
    else
    {
        return NO;
    }
}
-(BOOL) cancelConnection
{
    self.activeDownloadData = nil;
    if (self.myURLStr != nil) 
    {
        return [self cancelConnection:self.myURLStr];
    }
    else
    {
        return NO;
    }
}

-(id)init
{
    if (self = [super init]) 
    {
        self.activeDownloadData = [NSData data];
    }
    return self;
}

-(void)dealloc
{
    self.myURLStr = nil;
    self.myConnection = nil;
    [super dealloc];
}
@end
