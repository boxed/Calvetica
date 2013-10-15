//
//  CVGestureHowToViewController.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVGestureHowToViewController.h"
#import "UILabel+Utilities.h"


@interface CVGestureHowToViewController () <UIScrollViewDelegate>
@property (nonatomic, weak  ) IBOutlet UIScrollView   *scrollView;
@property (nonatomic, weak  ) IBOutlet UIView         *titleView;
@property (nonatomic, weak  ) IBOutlet UIImageView    *shadow;
@property (nonatomic, weak  ) IBOutlet UILabel        *titleLabel;
@property (nonatomic, weak  ) IBOutlet UIPageControl  *pageControl;
@property (nonatomic, strong)          NSMutableArray *availableGestures;
@end


@implementation CVGestureHowToViewController

- (void)dealloc
{
    _scrollView.delegate = nil;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;

	_availableGestures = [NSMutableArray array];


	// add the info about each screen to the array
	// verify which device they're on if ipad don't show the screens that aren't applicable
	if (PAD) {

		NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
		NSString *title1 = @"Pinch zoom in/out to the right of the month to switch between the three day view options: Full day, agenda and week.";
		NSString *image1 = @"pinch_ipad";
		[dict1 setObject:title1 forKey:@"title"];
		[dict1 setObject:image1 forKey:@"image"];
		[_availableGestures addObject:dict1];

		NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] init];
		NSString *title2 = @"Swipe the month view with 3 fingers to show the week view.";
		NSString *image2 = @"threefingers_ipad";
		[dict2 setObject:title2 forKey:@"title"];
		[dict2 setObject:image2 forKey:@"image"];
		[_availableGestures addObject:dict2];

		NSMutableDictionary *dict3 = [[NSMutableDictionary alloc] init];
		NSString *title3 = @"Swipe up on the week view with 3 fingers to close the week view.";
		NSString *image3 = @"closemonth_ipad";
		[dict3 setObject:title3 forKey:@"title"];
		[dict3 setObject:image3 forKey:@"image"];
		[_availableGestures addObject:dict3];

		NSMutableDictionary *dict4 = [[NSMutableDictionary alloc] init];
		NSString *title4 = @"Tap and hold on the month name (JAN 2011) in the red toolbar to jump to today.";
		NSString *image4 = @"today_ipad";
		[dict4 setObject:title4 forKey:@"title"];
		[dict4 setObject:image4 forKey:@"image"];
		[_availableGestures addObject:dict4];

		NSMutableDictionary *dict5 = [[NSMutableDictionary alloc] init];
		NSString *title5 = @"Tap and hold on the plus icon (+) in the red toolbar to add a quick reminder.";
		NSString *image5 = @"quickreminder_ipad";
		[dict5 setObject:title5 forKey:@"title"];
		[dict5 setObject:image5 forKey:@"image"];
		[_availableGestures addObject:dict5];

		NSMutableDictionary *dict6 = [[NSMutableDictionary alloc] init];
		NSString *title6 = @"Tap and hold on a day in the month view to add an event there, or tap and hold on a time in the landscape week view.";
		NSString *image6 = @"longpressday_ipad";
		[dict6 setObject:title6 forKey:@"title"];
		[dict6 setObject:image6 forKey:@"image"];
		[_availableGestures addObject:dict6];
	}
	else {

		NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
		NSString *title1 = @"Pinch zoom in/out below the month to switch between the three day view options: Full day, agenda and week.";
		NSString *image1 = @"pinch_iphone";
		[dict1 setObject:title1 forKey:@"title"];
		[dict1 setObject:image1 forKey:@"image"];
		[_availableGestures addObject:dict1];

		NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] init];
		NSString *title2 = @"Swipe left and right in the month area to quickly switch between months, moving forward or backward in time.";
		NSString *image2 = @"monthswipe_iphone";
		[dict2 setObject:title2 forKey:@"title"];
		[dict2 setObject:image2 forKey:@"image"];
		[_availableGestures addObject:dict2];

		NSMutableDictionary *dict3 = [[NSMutableDictionary alloc] init];
		NSString *title3 = @"Swipe up in the month area to slide the month view up out of the way.";
		NSString *image3 = @"monthswipeup_iphone";
		[dict3 setObject:title3 forKey:@"title"];
		[dict3 setObject:image3 forKey:@"image"];
		[_availableGestures addObject:dict3];

		NSMutableDictionary *dict4 = [[NSMutableDictionary alloc] init];
		NSString *title4 = @"Tap and hold on the month name (JAN 2011) in the red toolbar to jump to today.";
		NSString *image4 = @"longpressmonth_iphone";
		[dict4 setObject:title4 forKey:@"title"];
		[dict4 setObject:image4 forKey:@"image"];
		[_availableGestures addObject:dict4];

		NSMutableDictionary *dict5 = [[NSMutableDictionary alloc] init];
		NSString *title5 = [NSString stringWithFormat:@"Tap and hold on the plus icon (+) in the red toolbar to add a quick reminder."];
		NSString *image5 = @"quickreminder_iphone";
		[dict5 setObject:title5 forKey:@"title"];
		[dict5 setObject:image5 forKey:@"image"];
		[_availableGestures addObject:dict5];

		NSMutableDictionary *dict6 = [[NSMutableDictionary alloc] init];
		NSString *title6 = @"Tap and hold on a day in the month view to add an event there, or tap and hold on a time in the landscape week view.";
		NSString *image6 = @"longpressday_iphone";
		[dict6 setObject:title6 forKey:@"title"];
		[dict6 setObject:image6 forKey:@"image"];
		[_availableGestures addObject:dict6];
	}

	NSMutableDictionary *dict7 = [[NSMutableDictionary alloc] init];
	NSString *title7 = @"In the view popup menu, tap and hold the week option to switch styles, or use the shake gesture while in week mode";
	NSString *image7 = @"longtap_week";
	[dict7 setObject:title7 forKey:@"title"];
	[dict7 setObject:image7 forKey:@"image"];
	[_availableGestures addObject:dict7];

    self.navigationItem.title = @"Gestures How To";
}

- (void)viewWillAppear:(BOOL)animated
{
    self.contentSizeForViewInPopover = CGSizeMake(320, 416);
}

- (void)viewDidAppear:(BOOL)animated
{
	NSInteger currentX = 0;
    NSInteger currentY = 0;
    NSInteger imageWidth = _scrollView.frame.size.width;
    NSInteger imageHeight = _scrollView.frame.size.height;

    for (NSInteger i = 0; i < _availableGestures.count; i++) {

        NSMutableDictionary *dict = [_availableGestures objectAtIndex:i];

        NSString *imageName = [dict objectForKey:@"image"];
        UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];

        view.frame = CGRectMake(currentX, currentY, imageWidth, imageHeight);
        [_scrollView addSubview:view];
        currentX += imageWidth;
    }

    _scrollView.contentSize = CGSizeMake(currentX, imageHeight);
    _scrollView.delegate = self;

    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = _availableGestures.count;
    [self updateTitle];

	[self updateViewConstraints];
}




#pragma mark - Public Methods

- (void)updateTitle 
{
    
    // change the text for the current page
    NSInteger page = _pageControl.currentPage;
    NSMutableDictionary *dict = [_availableGestures objectAtIndex:page];
    _titleLabel.text = [dict objectForKey:@"title"];
    
    NSInteger viewX = _titleView.frame.origin.x;
    NSInteger viewY = _titleView.frame.origin.y;
    NSInteger viewWidth = _titleView.bounds.size.width;
    NSInteger viewHeight = _titleView.bounds.size.height;
    
    // adjust the height of the red bar
    if (_titleLabel.numberOfLines > 1) {
        viewHeight = [_titleLabel totalHeightOfWordWrapTextInLabelWithConstraintWidth:_titleLabel.bounds.size.width] + 30;
    }
    
    [UIView animateWithDuration:0.2 animations:^(void) {
        _titleView.frame = CGRectMake(viewX, viewY, viewWidth, viewHeight);
        _shadow.frame = CGRectMake(0, viewHeight, 320, 5);
    }];
}



#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = _scrollView.frame.size.width;
    NSInteger page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
    [self updateTitle];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
