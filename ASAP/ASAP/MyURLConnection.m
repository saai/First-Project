//
//  MyURLConnection.m
//  ASAP
//
//  Created by Sha Yan on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyURLConnection.h"

@implementation MyURLConnection
@synthesize delegate,callBackMethodString;
@synthesize activeDownload, myConnection,connectionKey;

-(BOOL) startConnectionWithKey:(NSString *)key request:(NSURLRequest *)request callBackMethod:(SEL) method
{
    self.callBackMethodString = NSStringFromSelector(method);
    self.connectionKey = key;
    [self.myConnection cancel];
    self.myConnection = [[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO] autorelease];
    [myConnection start];
    return YES;
}
-(BOOL) cancelConnection
{
    [self.myConnection cancel];
    self.activeDownload = nil;
    self.myConnection = nil;
    self.connectionKey = nil;
    self.callBackMethodString = nil;
    return YES;
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //[response URL] equals to our method string 
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (delegate !=nil && [delegate respondsToSelector:@selector(connectionDidFailWithError:connectionKey:callBackMethod:)]) 
    {
        SEL callBackMethod = NSSelectorFromString(callBackMethodString) ;
        [delegate connectionDidFailWithError:error connectionKey:connectionKey callBackMethod:callBackMethod];
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (delegate != nil && [delegate respondsToSelector:@selector(connectionDidEndDownload:connectionKey:callBackMethod:)]) 
    {
        SEL callBackMethod = NSSelectorFromString(callBackMethodString) ;
        [delegate connectionDidEndDownload:activeDownload connectionKey:connectionKey callBackMethod:callBackMethod];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData: data];
}

- (void)dealloc
{
    self.delegate = nil;
    self.callBackMethodString = nil;
    self.activeDownload = nil;
    self.myConnection = nil;
    self.connectionKey = nil;
    [super dealloc];
}
@end
