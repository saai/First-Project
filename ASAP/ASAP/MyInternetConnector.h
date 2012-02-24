//
//  MyInternetConnector.h
//  ASAP
//
//  Created by Sha Yan on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kConnectionTimeOutInterval 20

@interface MyInternetConnector : NSObject<NSURLConnectionDelegate>
{
    NSMutableData *activeDownloadData;
    NSURLConnection *connection;
    
}
@property (nonatomic, retain) NSMutableData *activeDownloadData;
@property (nonatomic, retain) NSURLConnection *connection;
@end
