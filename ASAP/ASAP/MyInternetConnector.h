//
//  MyInternetConnector.h
//  ASAP
//
//  Created by Sha Yan on 12-2-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kConnectionTimeOutInterval 20

@interface MyInternetConnector : NSObject
{
    NSMutableArray *allConnections;
    id target;
}
@property (nonatomic, retain) NSMutableArray *allConnections;
@property (nonatomic, assign) id target;

-(void) assignTargetToConnector:(id) newTarget;
-(void) removeTargetFromConnector;
-(BOOL) cancelAllConnections;
-(BOOL) startConnectionWithURLString: (NSString *) urlStr;
-(BOOL) startConnectionWithMethod: (NSString *)methodName options:(NSDictionary *) options;
-(BOOL) cancelConnection:(NSString *) urlStr;
-(BOOL) startConnection;
-(BOOL) cancelConnection;

// these methods depends on the API of the web server.
-(NSURLRequest *)generateRequestWithURL : (NSString *)urlStr;
-(NSURLRequest *)generateRequestWithMethod:(NSString *) methodName options:(NSDictionary *) options;
@end
