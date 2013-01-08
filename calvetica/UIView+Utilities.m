//
//  UIView+Utilities.m
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UIView+Utilities.h"


@implementation UIView (UIView_Utilities)

- (void)bounce 
{
//	[UIView animateWithDuration:0.1 animations:^(void) {
//		CGRect f = self.frame;
//		f.origin.y -= 5;
//		self.frame = f;
//	} completion:^(BOOL finished) {
//		[UIView animateWithDuration:0.1 animations:^(void) {
//			CGRect f = self.frame;
//			f.origin.y += 5;
//			self.frame = f;			
//		}];
//	}];
	
	
	dispatch_queue_t animationQueue = dispatch_queue_create("com.mysterioustrousers.animationqueue", NULL);
	dispatch_async(animationQueue, ^(void) {
		
		for (NSInteger i = 5; i >= 0; i -= 1) {
			[NSThread sleepForTimeInterval:0.01];
			dispatch_async(dispatch_get_main_queue(), ^(void) {
				CGRect f = self.frame;
				f.origin.y -= 1;
				self.frame = f;
			});
		}

		for (NSInteger i = 5; i >= 0; i -= 1) {
			[NSThread sleepForTimeInterval:0.01];
			dispatch_async(dispatch_get_main_queue(), ^(void) {
				CGRect f = self.frame;
				f.origin.y += 1;
				self.frame = f;
			});
		}
	});
}

@end
