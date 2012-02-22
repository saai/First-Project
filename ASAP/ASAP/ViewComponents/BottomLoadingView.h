//
//  BottomLoadingView.h
//  ASAP
//
//  Created by Sha Yan on 11-9-5.
//  Copyright 2011 ShaYan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HIGHT_OF_BOTTOM_LOADINGVIEW 40.0f

@interface BottomLoadingView : UIView {
    
	UIActivityIndicatorView *loadingIndicator;
	UIImageView *directionImageView;
	UILabel *titleLabel;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, retain) IBOutlet UIImageView *directionImageView;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;

@end
