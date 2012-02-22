//
//  AutoRefreshHeaderView.h
//  ASAP
//
//  Created by Sha Yan on 11-8-30.
//  Copyright 2011 ShaYan. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SLIDE_DOWN_IMAGE @"ic_pulltorefresh_arrow_down.png"
#define SLIDE_UP_IMAGE @"ic_pulltorefresh_arrow_up.png"


#define HIGHT_OF_AUTOREFRESH_HEADERVIEW 40.0f

@interface AutoRefreshHeaderView : UIView {
	UILabel *titleLabel;
	UIActivityIndicatorView *loadingIndicator;
	UIImageView *directionImageView;
}

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, retain) IBOutlet UIImageView *directionImageView;

@end
