//
//  MyURLConnection.m
//  ASAP
//
//  Created by Sha Yan on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyURLConnection.h"

@implementation MyURLConnection
@synthesize activeDownload, myConnection,delegate;
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //[response URL] equals to our method string 
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (delegate != nil && [delegate respondsToSelector:@selector(connectionDidEndDownload:)]) 
    {
        [delegate connectionDidEndDownload:activeDownload];
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
}

@end
