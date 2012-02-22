//
//  AutoRefreshViewController.h
//  ASAP
//
//  Created by Sha Yan on 11-8-30.
//  Copyright 2011 ShaYan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoRefreshHeaderView.h"
#import "BottomLoadingView.h"

#define DRAG_DOWN_TIP @"Pull to refresh..."
#define RELEASE_TIP @"Release to refresh..."
#define LOADING_TIP @"Loading..."
#define DRAG_UP_TIP @"Pull to load more..."
#define RELEASE_TO_LOAD_MORE @"Release to load more..."

@class AutoRefreshHeaderView;
@interface AutoRefreshViewController : UIViewController <UITableViewDelegate>{
	BOOL isLoadNewEnabled;
    BOOL isLoadMoreEnabled;
    
    AutoRefreshHeaderView *topHeaderView;
    BottomLoadingView *bottomLoadingView;
    
	BOOL isLoadingNew;
	BOOL isLoadingMore;
	BOOL isDragging;
    BOOL hasLoadMoreCell;
    BOOL hasLoadNewHeaderView;
	NSString *textRelease;
	NSString *textDrag;
	NSString *textLoading;
    NSString *textDragUpToLoadMore;
    NSString *textReleaseToLoadMore;
    
	UITableView * newTableView;
    BOOL isTableBusy;// we should not change the data source when the table is busy
}

@property (nonatomic, readwrite) BOOL isLoadNewEnabled;
@property (nonatomic, readwrite) BOOL isLoadMoreEnabled;

@property (nonatomic, retain) AutoRefreshHeaderView *topHeaderView;
@property (nonatomic, retain) BottomLoadingView *bottomLoadingView;
@property (nonatomic, readwrite) BOOL isLoadingNew;
@property (nonatomic, readwrite) BOOL isLoadingMore;
@property (nonatomic, readwrite) BOOL isDragging;
@property (nonatomic, readwrite) BOOL hasLoadMoreCell;
@property (nonatomic, readwrite) BOOL hasLoadNewHeaderView;

@property (nonatomic, copy)	NSString *textRelease;
@property (nonatomic, copy)	NSString *textDrag;
@property (nonatomic, copy)	NSString *textLoading;
@property (nonatomic, copy)	NSString *textDragUpToLoadMore;
@property (nonatomic, copy)	NSString *textReleaseToLoadMore;
@property (nonatomic, retain, getter=theNewTableView) IBOutlet UITableView * newTableView;
@property (nonatomic, readwrite) BOOL isTableBusy;

- (void)refresh;
- (void)endRefresh;
- (void)startLoading;
- (void)stopLoading;
- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
- (void)stopLoadingImmediately;

- (void)loadMore;
- (void)endLoadMore;
- (void)startloadingMore;
- (void)stopLoadingMore;
- (void)stopLoadingMoreComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

- (void)hideLoadNewHeader: (BOOL) hidden;
@end
