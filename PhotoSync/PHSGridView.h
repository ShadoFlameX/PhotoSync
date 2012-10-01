//
//  PHSGridView.h
//  PhotoSync
//
//  Created by Bryan Hansen on 9/30/12.
//  Copyright (c) 2012 skeuo. All rights reserved.
//

@class PHSGridView;

@class PHSGridView;

@protocol PHSGridViewDatasource <NSObject>
@required
- (NSUInteger)numberOfItemsInGridView:(PHSGridView *)gridView;
- (TUIView *)gridView:(PHSGridView *)gridView itemForIndex:(NSUInteger)index;
@end

@interface PHSGridView : TUIScrollView

@property (nonatomic, weak) id <PHSGridViewDatasource> dataSource;
@property (nonatomic) CGSize itemSize;

//- (TUIView *)indexForItem:(TUIView *)itemView;
- (void)reloadData;

@end
