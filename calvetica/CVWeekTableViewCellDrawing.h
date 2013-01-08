//
//  CVWeekTableViewCellDrawing.h
//  calvetica
//
//  Created by Adam Kirk on 3/29/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//


@protocol CVWeekTableViewCellDrawingDataSource;




@interface CVWeekTableViewCellDrawing : UIView

@property (nonatomic, unsafe_unretained) id<CVWeekTableViewCellDrawingDataSource> delegate;
@property (nonatomic, strong) NSArray *dataHolders;

- (NSArray *)prepareDataHolders;
- (void)draw;

@end




@protocol CVWeekTableViewCellDrawingDataSource <NSObject>
@required
- (NSDate *)startDateForDrawingView:(CVWeekTableViewCellDrawing *)view;
@end