//
//  MyInternetConnector.h
//  ASAP
//
//  Created by Sha Yan on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyURLConnectionDelegate.h"
#define kConnectionTimeOutInterval 20

@interface MyInternetConnector : NSObject<MyURLConnectionDelegate>
{
    id target;
    NSMutableDictionary *allConnections;

}
@property (nonatomic, assign) id target;
@property (nonatomic, retain) NSMutableDictionary *allConnections;


-(void) assignTargetToConnector:(id) newTarget;
-(void) removeTargetFromConnector;

-(BOOL) startConnectionWithURLString: (NSString *) urlStr callBackMethod:(SEL) callBackMethod;
-(BOOL) startConnectionWithMethod: (NSString *)methodName options:(NSDictionary *) options callBackMethod:(SEL) callBackMethod;
-(BOOL) cancelConnection:(NSString *) connectionKey;
-(BOOL) cancelAllConnections;
// these methods depends on the API of the web server.
-(NSURLRequest *)generateRequestWithURL : (NSString *)urlStr;
-(NSURLRequest *)generateRequestWithMethod:(NSString *) methodName options:(NSDictionary *) options;
@end
