    //
//  AutoRefreshViewController.m
//  ASAP
//
//  Created by Sha Yan on 11-8-30.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AutoRefreshViewController.h"
#import "AutoRefreshHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation AutoRefreshViewController
@synthesize topHeaderView,isLoadingNew, isLoadingMore, isDragging,hasLoadMoreCell,hasLoadNewHeaderView;
@synthesize textRelease,textDrag,textLoading;
@synthesize newTableView;
@synthesize isLoadNewEnabled, isLoadMoreEnabled;
@synthesize bottomLoadingView, textDragUpToLoadMore,textReleaseToLoadMore;
@synthesize isTableBusy;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.textRelease = RELEASE_TIP;
	self.textDrag = DRAG_DOWN_TIP;
	self.textLoading = LOADING_TIP;
    self.textDragUpToLoadMore = DRAG_UP_TIP;
    self.textReleaseToLoadMore = RELEASE_TO_LOAD_MORE;
	
    if (isLoadNewEnabled) 
    {
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"AutoRefreshHeaderView" owner:self options:nil];
        self.topHeaderView =(AutoRefreshHeaderView *) [array objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0-(HIGHT_OF_AUTOREFRESH_HEADERVIEW), self.topHeaderView.frame.size.width, self.topHeaderView.frame.size.height);
        self.topHeaderView.frame = newFrame;
        [self.newTableView addSubview:self.topHeaderView];
    }
	NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"BottomLoadingView" owner:nil options:nil];
	self.bottomLoadingView = (BottomLoadingView *) [array objectAtIndex:0];
	self.bottomLoadingView.titleLabel.text = self.textDragUpToLoadMore;
    
    
	self.newTableView.delegate = self;
	isLoadingNew = NO;
	isLoadingMore = NO;
	isDragging = NO;
    hasLoadMoreCell = NO;
    isTableBusy = NO;
	hasLoadNewHeaderView = isLoadNewEnabled;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[topHeaderView release];
	[textRelease release];
	[textDrag release];
	[textLoading release];
    
    [textReleaseToLoadMore release];
	[textDragUpToLoadMore release];
	[bottomLoadingView release];
    
	[newTableView release];
    [super dealloc];
}


#pragma mark -
#pragma mark Scroll view delegate
-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //if (isTableBusy) return;
    isDragging = YES;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat y = offsetY + scrollView.frame.size.height;
    CGFloat height = scrollView.contentSize.height;
    //NSLog(@"scroll offset %f", offsetY);
    if (!isLoadNewEnabled && !isLoadMoreEnabled) 
    {
        // no refresh header and load more 
        return;
    }
    
    if (isLoadNewEnabled && isLoadingNew && hasLoadNewHeaderView) 
    {
        // Update the content inset, good for section headers
        if (offsetY > 0)
            self.newTableView.contentInset = UIEdgeInsetsZero;
//        else if (offsetY >= -HIGHT_OF_AUTOREFRESH_HEADERVIEW)
//            self.newTableView.contentInset = UIEdgeInsetsMake(-offsetY, 0, 0, 0);
        
    } 
    else if (!isTableBusy && isLoadNewEnabled && isDragging && offsetY < 0 && hasLoadNewHeaderView) 
    {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -HIGHT_OF_AUTOREFRESH_HEADERVIEW) 
        {
            // User is scrolling above the header
            self.topHeaderView.titleLabel.text = self.textRelease;
            [self.topHeaderView.directionImageView layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } 
        else 
        { // User is scrolling somewhere within the header
            self.topHeaderView.titleLabel.text = self.textDrag;
            [self.topHeaderView.directionImageView layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
    }
    else if(!isTableBusy && isLoadMoreEnabled && isDragging && hasLoadMoreCell && y >= height-HIGHT_OF_BOTTOM_LOADINGVIEW ) 
	{
		// Update the label in bottom cell
		// Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (y > height) 
		{
            // User is scrolling under load more cell;
            self.bottomLoadingView.titleLabel.text = self.textReleaseToLoadMore;
            [self.bottomLoadingView.directionImageView layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        } 
		else 
		{ 
            // User is scrolling somewhere within the bottom
            self.bottomLoadingView.titleLabel.text = self.textDragUpToLoadMore;
            [self.bottomLoadingView.directionImageView layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        }
        [UIView commitAnimations];
	}
    
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    isDragging = NO;
    if (isTableBusy) return;
    
    if (isLoadNewEnabled && scrollView.contentOffset.y <= -HIGHT_OF_AUTOREFRESH_HEADERVIEW && hasLoadNewHeaderView) 
	{
        // Released above the header
        [self startLoading];
    }
    else if(isLoadMoreEnabled && (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height) && hasLoadMoreCell)
	{
        [self startloadingMore];
	}
}


#pragma mark -
#pragma mark Custom Methods

- (void)startLoading
{
	//NSLog(@"start Loading New");
	isLoadingNew = YES;
    isTableBusy = YES;
    if (isLoadNewEnabled) 
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.newTableView.contentInset = UIEdgeInsetsMake(HIGHT_OF_AUTOREFRESH_HEADERVIEW, 0, 0, 0);
        topHeaderView.titleLabel.text = self.textLoading;
        topHeaderView.directionImageView.hidden  = YES;
        [topHeaderView.loadingIndicator startAnimating];
        [UIView commitAnimations];
    }
	[self refresh];
	
	
}

- (void)refresh
{
	[self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}

- (void)endRefresh
{
	[self stopLoading];
}

- (void)stopLoading
{
	
	//NSLog(@"stop Loading New");
	isLoadingNew = NO;
	if (isLoadNewEnabled) 
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
        self.newTableView.contentInset = UIEdgeInsetsZero;
        [self.topHeaderView.directionImageView layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        [UIView commitAnimations];
    }	
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    //NSLog(@"Stop load new completed.");
    if (isLoadNewEnabled && !isLoadingNew) 
    {
        topHeaderView.titleLabel.text = self.textDrag;
        topHeaderView.directionImageView.hidden = NO;
        [topHeaderView.loadingIndicator stopAnimating];
    }
    isTableBusy = NO;
}

- (void)stopLoadingImmediately
{
    //NSLog(@"stop Loading immediately");
    isTableBusy = NO;
	if (isLoadingNew ) 
    {
        isLoadingNew = NO;
        if (isLoadNewEnabled) 
        {
            self.newTableView.contentInset = UIEdgeInsetsZero;
            [self.topHeaderView.directionImageView layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            topHeaderView.titleLabel.text = self.textDrag;
            topHeaderView.directionImageView.hidden = NO;
            [topHeaderView.loadingIndicator stopAnimating];
        }
    }
    if (isLoadingMore) 
    {
        isLoadingMore = NO;
        if (isLoadMoreEnabled) 
        {
            [self.bottomLoadingView.directionImageView layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            bottomLoadingView.titleLabel.text = self.textDragUpToLoadMore;
            bottomLoadingView.directionImageView.hidden = NO;
            [bottomLoadingView.loadingIndicator stopAnimating];
        }
    }


}


- (void)loadMore
{
    [self performSelector:@selector(stopLoadingMore) withObject:nil afterDelay:2.0];   
}
- (void)endLoadMore
{
    [self stopLoadingMore];
}

- (void)startloadingMore
{
	
	//NSLog(@"start Loading More");
	isLoadingMore = YES;
    isTableBusy = YES;
    if (isLoadMoreEnabled) 
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [self.bottomLoadingView.loadingIndicator startAnimating];
        self.bottomLoadingView.titleLabel.text = self.textLoading;
        self.bottomLoadingView.directionImageView.hidden = YES;
        [UIView commitAnimations];
    }
	[self loadMore];
}
- (void)stopLoadingMore 
{
	
	//NSLog(@"stop Loading More");
	// Reset the Load More
	//self.bottomLoadingView.titleLabel.text =
	isLoadingMore = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingMoreComplete:finished:context:)];
    [self.bottomLoadingView.directionImageView layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
}

- (void)stopLoadingMoreComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context 
{
    if (isLoadMoreEnabled) 
    {
        // Reset the header
        bottomLoadingView.titleLabel.text = self.textDragUpToLoadMore;
        bottomLoadingView.directionImageView.hidden = NO;
        [bottomLoadingView.loadingIndicator stopAnimating];
    }
    isTableBusy = NO;
}

- (void)hideLoadNewHeader: (BOOL) hidden
{
    if (isLoadNewEnabled) 
    {
        if (hidden) 
        {
            [self.topHeaderView removeFromSuperview];
            hasLoadNewHeaderView = NO;
        }
        else 
        {
            if (self.topHeaderView.superview == nil) 
            {
                CGRect newFrame = CGRectMake(0, 0-(HIGHT_OF_AUTOREFRESH_HEADERVIEW), self.topHeaderView.frame.size.width, self.topHeaderView.frame.size.height);
                self.topHeaderView.frame = newFrame;
                [self.newTableView addSubview:self.topHeaderView];
                hasLoadNewHeaderView = YES;
            }
        }
    }
}
@end
