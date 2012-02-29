//
//  MyInternetConnector.h
//  ASAP
//
//  Created by Sha Yan on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kConnectionTimeOutInterval 20

@interface MyInternetConnector : NSObject< NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    NSMutableData *activeDownloadData;
    NSURLConnection *myConnection;
    NSString *myURLStr;
}
@property (nonatomic, retain) NSMutableData *activeDownloadData;
@property (nonatomic, retain) NSURLConnection *myConnection;
@property (nonatomic, retain) NSString *myURLStr;


-(BOOL) startConnectionWithURLString: (NSString *) urlStr;
-(BOOL) cancelConnection:(NSString *) urlStr;
-(BOOL) startConnection;
-(BOOL) cancelConnection;
@end
