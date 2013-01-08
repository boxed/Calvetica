//
//  CVAutoResizableLabel.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


#define DEFAULT_MAX 31.0f
#define DEFAULT_MIN 31.0f
#define DEFAULT_PADDING CGSizeMake(15.0f, 15.0f)

@interface CVAutoResizableLabel : UILabel


#pragma mark - Properties
@property (nonatomic, assign) BOOL autoResize;
@property (nonatomic, assign) CGFloat maximumHeight;
@property (nonatomic, assign) CGFloat minimumHeight;
@property (nonatomic, assign) CGFloat maximumWidth;
@property (nonatomic, assign) CGFloat minimumWidth;
@property (nonatomic, assign) CGSize padding;


#pragma mark - Methods
- (void)setDefaults;
- (void)sizeToFitWithAnimation;


#pragma mark - IBActions


@end
