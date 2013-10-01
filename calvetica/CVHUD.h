//
//  CVBezel.h
//  calvetica
//
//  Created by James Schultz on 6/30/11.
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

// to use this class simply instantiate an instance, set the titleLabel.text
// and then add it to your view and call presentBezel

#import <QuartzCore/QuartzCore.h>
#import "UILabel+Utilities.h"
#import "CVDebug.h"

@interface CVHUD : UIView {
}

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

- (void)presentBezel;

@end