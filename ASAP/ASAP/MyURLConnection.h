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
    id<MyURLConnectionDelegate> delegate;
    NSString *callBackMethodString;
    NSURLConnection *myConnection;
    NSMutableData *activeDownload;
    NSString *connectionKey;
    
}
@property(nonatomic, assign)id<MyURLConnectionDelegate> delegate;
@property(nonatomic, assign)NSString* callBackMethodString;
@property(nonatomic, retain)NSURLConnection *myConnection;
@property(nonatomic, retain)NSMutableData *activeDownload;
@property(nonatomic, copy)NSString *connectionKey;


-(BOOL) startConnectionWithKey:(NSString *)key request:(NSURLRequest *)request callBackMethod:(SEL) method;
-(BOOL) cancelConnection;
@end
