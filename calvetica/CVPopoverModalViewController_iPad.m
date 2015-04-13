//
//  CVPageModalViewController_iPad.m
//  calvetica
//
//  Created by Adam Kirk on 5/30/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "CVPopoverModalViewController_iPad.h"
#import "geometry.h"


typedef struct {
	CVPopoverArrowDirection arrowDirection;
	CGPoint point;
} popover_arrow_direction_point;


@interface CVPopoverModalViewController_iPad ()
@property (nonatomic, weak  ) IBOutlet UIView            *modalViewContainer;
@property (nonatomic, weak  ) IBOutlet CVPopoverBackdrop *popoverBackdropView;
@end


@implementation CVPopoverModalViewController_iPad


#pragma mark - Methods

- (id)initWithContentViewController:(CVViewController<CVModalProtocol> *)initContentViewController targetView:(UIView *)initTargetView 
{
    self = [super init];
    if (self) {
        self.contentViewController = initContentViewController;
        self.contentViewController.containingViewController = self;
		self.targetView = initTargetView;
		keyboardAppearedModalSavedYCoord = -1;
    }
    return self;
}

- (void)dealloc 
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self layout];

    // add content to view controller
    [self.modalViewContainer addSubview:_contentViewController.view];

    // if the keyboard appears, we need our popover to scoot up to the top of the screen
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.popoverBackdropView = nil;
    self.modalViewContainer = nil;
    [super viewDidUnload];
}




#pragma mark - Public

- (void)setIgnoreKeyboard:(BOOL)ignoreKeyboard
{
    _ignoreKeyboard = ignoreKeyboard;

    if (ignoreKeyboard) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    else {
        // if the keyboard appears, we need our popover to scoot up to the top of the screen
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
}




#pragma mark - Notifications

- (void)keyboardWillShow:(NSNotification *)aNotification 
{
	CGRect f = _modalViewContainer.frame;
	UIView *rootView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
	keyboardAppearedModalSavedYCoord = -1;
	
	NSDictionary* info = [aNotification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	kbRect = [self.view convertRect:kbRect fromView:nil];

	// if the modal will be hidden behind the keyboard push it up with the keyboard
	if ((f.origin.y + f.size.height) > (rootView.bounds.size.height - kbRect.size.height)) {
        // save state
        keyboardAppearedModalSavedYCoord        = f.origin.y;
        keyboardAppearedArrowSavedDirection     = self.popoverBackdropView.arrowDirection;
        self.popoverBackdropView.arrowDirection = CVPopoverArrowDirectionNone;

        // move it up
		[UIView mt_animateWithDuration:0.4
                        timingFunction:kMTEaseOutBack
                               options:UIViewAnimationOptionBeginFromCurrentState
                            animations:^
        {
            CGFloat y = MAX(20, self.view.bounds.size.height - kbRect.size.height - self.modalViewContainer.height - 20);
            self.modalViewContainer.y = y;
        } completion:nil];
	}
}

- (void)keyboardWillHide 
{
	if (keyboardAppearedModalSavedYCoord != -1) {
		[UIView mt_animateWithDuration:0.4
                        timingFunction:kMTEaseOutBack
                               options:UIViewAnimationOptionBeginFromCurrentState
                            animations:^
         {
             self.modalViewContainer.y = keyboardAppearedModalSavedYCoord;
             self.popoverBackdropView.arrowDirection = keyboardAppearedArrowSavedDirection;
         } completion:nil];
	}
}

- (CVPopoverArrowDirection)bestEnumMatch:(CVPopoverArrowDirection)direction inMask:(CVPopoverArrowDirection)directionMask 
{
	// if its contained within the mask, its the best match
	if ((direction & directionMask) == direction) {
		return direction;
	}

	
	// create a point for all the enums and then use distance formula to find closest
	popover_arrow_direction_point points[12];
	
	for (NSInteger i = 1; i <= 12; i++) {
		popover_arrow_direction_point p;
		
		if (i == 1) {
			p.arrowDirection = CVPopoverArrowDirectionTopLeft;
			p.point = CGPointMake(0, 0);
		}
		else if (i == 2) {
			p.arrowDirection = CVPopoverArrowDirectionTopMiddle;
			p.point = CGPointMake(1, 0);
		}
		else if (i == 3) {
			p.arrowDirection = CVPopoverArrowDirectionTopRight;
			p.point = CGPointMake(2, 0);
		}
		else if (i == 4) {
			p.arrowDirection = CVPopoverArrowDirectionBottomLeft;
			p.point = CGPointMake(0, 4);
		}
		else if (i == 5) {
			p.arrowDirection = CVPopoverArrowDirectionBottomMiddle;
			p.point = CGPointMake(1, 4);
		}
		else if (i == 6) {
			p.arrowDirection = CVPopoverArrowDirectionBottomRight;
			p.point = CGPointMake(2, 4);
		}
		else if (i == 7) {
			p.arrowDirection = CVPopoverArrowDirectionLeftTop;
			p.point = CGPointMake(0, 1);
		}
		else if (i == 8) {
			p.arrowDirection = CVPopoverArrowDirectionLeftMiddle;
			p.point = CGPointMake(0, 2);
		}
		else if (i == 9) {
			p.arrowDirection = CVPopoverArrowDirectionLeftBottom;
			p.point = CGPointMake(0, 3);
		}
		else if (i == 10) {
			p.arrowDirection = CVPopoverArrowDirectionRightTop;
			p.point = CGPointMake(2, 1);
		}
		else if (i == 11) {
			p.arrowDirection = CVPopoverArrowDirectionRightMiddle;
			p.point = CGPointMake(2, 2);
		}
		else if (i == 12) {
			p.arrowDirection = CVPopoverArrowDirectionRightBottom;
			p.point = CGPointMake(2, 3);
		}
		
		points[i-1] = p;
	}
	
	// find the point for passed in enum
	popover_arrow_direction_point passed_in_point;
	for (NSInteger i = 1; i <= 12; i++) {
		popover_arrow_direction_point p = points[i-1];
		if (p.arrowDirection == direction) {
			passed_in_point = p;
			break;
		}
	}
	
	// find the closest enum in the mask to the passed in direction
	popover_arrow_direction_point closest;
	closest.arrowDirection = CVPopoverArrowDirectionLeftTop;
	closest.point = CGPointMake(100, 100);
	for (NSInteger i = 1; i <= 12; i++) {
		popover_arrow_direction_point p = points[i-1];
		
		// see if this is in the mask
		if ((p.arrowDirection & directionMask) == p.arrowDirection) {
			
			// if it is, see if its closer to the passed in direction than the last one found in the mask
			CGFloat competitor = CVPointDistance(passed_in_point.point, p.point);
			CGFloat reigningChamp = CVPointDistance(passed_in_point.point, closest.point);
			if (competitor < reigningChamp) {
				closest = p;
			}
		}
	}

	
	// return the closest direction found.
	return closest.arrowDirection;
}

- (void)layout 
{
	// stretch the background to fill the whole screen
	CGRect viewBounds = self.containingViewController.view.bounds;
	[self.view setFrame:CGRectMake(0, 0, viewBounds.size.width, viewBounds.size.height)];
	
	// convert the views coordinates to the coordinates of the whole screen
	CGRect targetRect = [_targetView convertRect:_targetView.bounds toView:self.containingViewController.view];
	
	CVPopoverModalAttachToSide attachToSide = _contentViewController.attachPopoverArrowToSide;
	CVPopoverArrowDirection arrowDirection = _contentViewController.popoverArrowDirection;

    // determine the point at which the popover should point
    // this is done by figuring out which edge of the rectangle faces the center of the screen most, then finding the midpoint of that edge
    CGPoint screenCenter = CGPointMake(CGRectGetMidX(viewBounds), CGRectGetMidY(viewBounds));
	
	// if an attach to side is specified, change the compare point to the side of the screen, aligned with the middle of the edge the arrow should point to
	if (attachToSide == CVPopoverModalAttachToSideTop) {
		screenCenter = CGPointMake(CGRectGetMidX(targetRect), CGRectGetMinY(viewBounds));
	} else if (attachToSide == CVPopoverModalAttachToSideRight) {
		screenCenter = CGPointMake(CGRectGetMaxX(viewBounds), CGRectGetMidY(targetRect));
	} else if (attachToSide == CVPopoverModalAttachToSideBottom) {
		screenCenter = CGPointMake(CGRectGetMidX(targetRect), CGRectGetMaxY(viewBounds));
	} else if (attachToSide == CVPopoverModalAttachToSideLeft) {
		screenCenter = CGPointMake(CGRectGetMinX(viewBounds), CGRectGetMidY(targetRect));
	}
	

	// find the closest two points on the rect to the center of the screen
	CGPoint first;
	CGPoint second;
	CVRectClosestTwoPoints(targetRect, screenCenter, &first, &second);

	
    // finally, find the midpoint between the two closest points to the center of the screen
    CGPoint point = CVLineMidPoint(first, second);
	
	
	if (attachToSide == CVPopoverModalAttachToSideCenter) {
		point = CVRectCenterPoint(targetRect);
	}
	
	
	
	// remedies fuzziness
	point.x = roundf(point.x);
	point.y = roundf(point.y);
    
	
    
    // determine arrow direction and move view near point
    CGFloat xPercent = point.x / viewBounds.size.width;
    CGFloat yPercent = point.y / viewBounds.size.height;
    
    
	
	CGRect f = self.modalViewContainer.frame;
    
	
	
    // resize container to fit the content view controller size
    f.size.width = _contentViewController.view.frame.size.width;
    f.size.height = _contentViewController.view.frame.size.height;
    
	
	
    // how far view should be offset from the point so that the arrows tip points to it
    CGFloat arrowFloatDistance = POPOVER_SHADOW_PADDING + POPOVER_ARROW_HEIGHT;
    
	
	
	CVPopoverArrowDirection autoArrowDirection = CVPopoverArrowDirectionLeftTop;
	// top left
	if (yPercent < 0.1 && xPercent < 0.2) {
		autoArrowDirection = CVPopoverArrowDirectionTopLeft;
	}
	
	// top right
	else if (yPercent < 0.1 && xPercent >= 0.8) {
		autoArrowDirection = CVPopoverArrowDirectionTopRight;
	}
	
	// top middle
	else if (yPercent < 0.1) {
		autoArrowDirection = CVPopoverArrowDirectionTopMiddle;
	}
	
	// bottom left
	else if (yPercent >= 0.9 && xPercent < 0.2) {
		autoArrowDirection = CVPopoverArrowDirectionBottomLeft;
	}
	
	// bottom right
	else if (yPercent >= 0.9 && xPercent >= 0.8) {
		autoArrowDirection = CVPopoverArrowDirectionBottomRight;
	}
	
	// bottom middle
	else if (yPercent >= 0.9) {
		autoArrowDirection = CVPopoverArrowDirectionBottomMiddle;
	}
	
	// left top
	else if (yPercent < 0.33 && xPercent < 0.5) {
		autoArrowDirection = CVPopoverArrowDirectionLeftTop;
	}
	
	// left bottom
	else if (yPercent >= 0.66 && xPercent < 0.5) {
		autoArrowDirection = CVPopoverArrowDirectionLeftBottom;
	}
	
	// left middle
	else if (xPercent < 0.5) {
		autoArrowDirection = CVPopoverArrowDirectionLeftMiddle;
	}
	
	// right top
	else if (yPercent < 0.33 && xPercent >= 0.5) {
		autoArrowDirection = CVPopoverArrowDirectionRightTop;
	}
	
	// right bottom
	else if (yPercent >= 0.66 && xPercent >= 0.5) {
		autoArrowDirection = CVPopoverArrowDirectionRightBottom;
	}
	
	// right middle
	else {
		autoArrowDirection = CVPopoverArrowDirectionRightMiddle;
	}
	
	
	
	// find the closest matching arrow direction in the mask passed in (if no mask was passed in, it uses the automatic arrow direction)
	arrowDirection = [self bestEnumMatch:autoArrowDirection inMask:arrowDirection];
	
	
	
	
	// top left
    if (arrowDirection == CVPopoverArrowDirectionTopLeft) {
        f.origin.x = point.x;
        f.origin.y = point.y + arrowFloatDistance;
    }
	
    // top right
    else if (arrowDirection == CVPopoverArrowDirectionTopRight) {
        f.origin.x = point.x - f.size.width;
        f.origin.y = point.y + arrowFloatDistance;
    }
    
    // top middle
    else if (arrowDirection == CVPopoverArrowDirectionTopMiddle) {
        f.origin.x = point.x - (f.size.width / 2);
        f.origin.y = point.y + arrowFloatDistance;
    }
    
    // bottom left
    else if (arrowDirection == CVPopoverArrowDirectionBottomLeft) {
        f.origin.x = point.x;
        f.origin.y = point.y - f.size.height - arrowFloatDistance;
    }
    
    // bottom right
    else if (arrowDirection == CVPopoverArrowDirectionBottomRight) {
        f.origin.x = point.x - f.size.width;
        f.origin.y = point.y - f.size.height - arrowFloatDistance;
    }
    
    // bottom middle
    else if (arrowDirection == CVPopoverArrowDirectionBottomMiddle) {
        f.origin.x = point.x - (f.size.width / 2);
        f.origin.y = point.y - f.size.height - arrowFloatDistance;
    }
    
    // left top
    else if (arrowDirection == CVPopoverArrowDirectionLeftTop) {
        f.origin.x = point.x + arrowFloatDistance;
        f.origin.y = point.y;
    }
    
    // left bottom
    else if (arrowDirection == CVPopoverArrowDirectionLeftBottom) {
        f.origin.x = point.x + arrowFloatDistance;
        f.origin.y = point.y - f.size.height;
    }
    
    // left middle
    else if (arrowDirection == CVPopoverArrowDirectionLeftMiddle) {
        f.origin.x = point.x + arrowFloatDistance;
        f.origin.y = point.y - (f.size.height / 2);
    }
    
    // right top
    else if (arrowDirection == CVPopoverArrowDirectionRightTop) {
        f.origin.x = point.x - f.size.width - arrowFloatDistance;
        f.origin.y = point.y;
    }
    
    // right bottom
    else if (arrowDirection == CVPopoverArrowDirectionRightBottom) {
        f.origin.x = point.x - f.size.width - arrowFloatDistance;
        f.origin.y = point.y - f.size.height;
    }
    
    // right middle
    else if (arrowDirection == CVPopoverArrowDirectionRightMiddle) {
        f.origin.x = point.x - f.size.width - arrowFloatDistance;
        f.origin.y = point.y - (f.size.height / 2);
    }

	
	// make sure its on the screen
	CGFloat insetFromEdgeOfScreen = POPOVER_SHADOW_PADDING + POPOVER_BLACK_BORDER_WIDTH;
	if (f.origin.y < 0) {
		f.origin.y = insetFromEdgeOfScreen;
	}
	else if (f.origin.y + f.size.height > viewBounds.size.height) {
		f.origin.y = viewBounds.size.height - f.size.height - insetFromEdgeOfScreen;
	}
	
	if (f.origin.x < 0) {
		f.origin.x = insetFromEdgeOfScreen;
	}
	else if (f.origin.x + f.size.width > viewBounds.size.width) {
		f.origin.x = viewBounds.size.width - f.size.width - insetFromEdgeOfScreen;
	}
	
	
	
	
    
    // move the view the calculated location
    [self.modalViewContainer setFrame:f];
    
    // resize backdrop
    CGRect bf = f;
    bf.origin.x = 0;
    bf.origin.y = 0;
    bf = CGRectInset(bf, -POPOVER_BLACK_BORDER_WIDTH, -POPOVER_BLACK_BORDER_WIDTH);
    [self.popoverBackdropView setFrame:bf];
    
    // redraw the backdrop given the arrow direction
    self.popoverBackdropView.arrowDirection = arrowDirection;
	self.popoverBackdropView.backdropColor = _contentViewController.popoverBackdropColor;
    [self.popoverBackdropView setNeedsDisplay];
}




#pragma mark - View Controller Delegate

- (NSUInteger)supportedInterfaceOrientations
{
	return UIInterfaceOrientationMaskPortrait;
}







#pragma mark - Actions

- (IBAction)backdropWasTapped:(id)sender 
{
    // this is where the expected protocol method is called.  Any controller passed in much
    // conform to this protocol so that it will receive this message.
    [_contentViewController modalBackdropWasTouched];
}


@end
