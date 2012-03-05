//
//  MyURLConnection.h
//  ASAP
//
//  Created by Sha Yan on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyURLConnectionDelegate.h"
@interface MyURLConnection : NSObject< NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSURLConnection *myConnection;
    NSData *activeDownload;
    id<MyURLConnectionDelegate> delegate;
}

@property(nonatomic, retain)NSURLConnection *myConnection;
@property(nonatomic, retain)NSData *activeDownload;
@property(nonatomic, assign)id<MyURLConnectionDelegate> delegate;

@end
