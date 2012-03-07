//
//  MyURLConnectionDelegate.h
//  ASAP
//
//  Created by Sha Yan on 12-3-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MyURLConnectionDelegate <NSObject>
-(void) connectionDidEndDownload:(NSData *) downloadedData connectionKey:(NSString*) connectionKey callBackMethod:(SEL) callBackMethod;
-(void) connectionDidFailWithError:(NSError *) error connectionKey:(NSString *)connectionKey callBackMethod:(SEL) callBackMethod;
@end
