//
//  CVKnowledgeBaseDetailViewController.h
//  calvetica
//
//  Copyright 2011 Mysterious Trousers, LLC. All rights reserved.
//

#import "UITableViewCell+Nibs.h"
#import "KBQuestion.h"
#import "UILabel+Utilities.h"
#import "CVDebug.h"
#import "NSString+Utilities.h"


@interface CVKnowledgeBaseDetailViewController : UITableViewController {
@private
@protected
}

#pragma mark - Public Properties
@property (nonatomic, strong) KBQuestion *question;

#pragma mark - Public Methods


#pragma mark - Notifications


@end