//
//  CVWeekTableViewCellEvents.h
//  calvetica
//
//  Created by Adam Kirk on 3/23/12.
//  Copyright (c) 2012 Mysterious Trousers. All rights reserved.
//


@protocol CVWeekTableViewCellDrawingDataSource;


@interface CVWeekTableViewCellDrawing : UIView

@property (nonatomic, weak) id<CVWeekTableViewCellDrawingDataSource> delegate;
@property (nonatomic, copy) NSArray                                  *dataHolders;

- (NSArray *)prepareDataHolders;
- (void)draw;

@end



@protocol CVWeekTableViewCellDrawingDataSource <NSObject>
@required
- (NSDate *)startDateForDrawingView:(CVWeekTableViewCellDrawing *)view;
@end