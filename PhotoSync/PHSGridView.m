//
//  PHSGridView.m
//  PhotoSync
//
//  Created by Bryan Hansen on 9/30/12.
//  Copyright (c) 2012 skeuo. All rights reserved.
//

#import "PHSGridView.h"

static CGFloat const PHSGridViewMinimumPadding = 3.0f;

@interface PHSGridView () {
    BOOL _needsReloadData;
    BOOL _needsItemSizing;
}

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic) NSUInteger itemsPerRow;
@property (nonatomic) NSUInteger rowCount;
@property (nonatomic, readonly) CGFloat rowWidth;

@end

@implementation PHSGridView

#pragma mark - Properties

- (void)setDataSource:(id<PHSGridViewDatasource>)dataSource
{
    if (_dataSource == dataSource) return;
    
    _dataSource = dataSource;
    
    _needsReloadData = YES;
    [self setNeedsLayout];
}

- (void)setItemSize:(CGSize)itemSize
{
    if (CGSizeEqualToSize(_itemSize, itemSize)) return;
    
    _itemSize = itemSize;
    
    [self reloadData];
}

- (NSUInteger)itemsPerRow
{
    NSUInteger itemsPerRow = floorf(self.rowWidth / self.itemSize.width);
    
    // check if enough width exists for minimum item padding
    if (itemsPerRow * self.itemSize.width + (PHSGridViewMinimumPadding * (itemsPerRow - 1)) > self.rowWidth) {
        --itemsPerRow;
    }
    
    // force there to be at least 1 item per row
    return MAX(itemsPerRow, 1);
}

- (NSUInteger)rowCount
{
    NSUInteger itemCount = [self.dataSource numberOfItemsInGridView:self];
    NSUInteger itemsPerRow = self.itemsPerRow;
    NSUInteger rows = itemCount / itemsPerRow;
    
    if (itemCount % itemsPerRow != 0) rows ++;
    
    return rows;
}

- (CGFloat)rowWidth
{
    return self.bounds.size.width - self.contentInset.left - self.contentInset.right;
}


#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [NSColor blackColor];
        self.horizontalScrollIndicatorVisibility = TUIScrollViewIndicatorVisibleNever;
        self.verticalScrollIndicatorVisibility = TUIScrollViewIndicatorVisibleWhenMouseInside;
        
        self.items = [NSMutableArray array];
        self.itemSize = CGSizeMake(100.0f, 100.0f);        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_needsReloadData) [self reloadData];
}


#pragma mark - Content

- (void)reloadData
{
    if (!_needsReloadData) return;
    
    NSUInteger rowCount = self.rowCount;
    
    CGFloat height = rowCount * self.itemSize.height + self.contentInset.top;
    if (self.rowCount > 0) height += (rowCount - 1) * PHSGridViewMinimumPadding;
    
    self.contentSize = CGSizeMake(self.rowWidth, height);
    
    [self layoutItems];
    
    _needsReloadData = NO;
}

- (void)layoutItems
{
    [self.items enumerateObjectsUsingBlock:^(TUIView *subview, NSUInteger idx, BOOL *stop) {
        [subview removeFromSuperview];
    }];
    
    [self.items removeAllObjects];
    
    NSUInteger itemCount = [self.dataSource numberOfItemsInGridView:self];
    NSUInteger itemsPerRow = self.itemsPerRow;
    
    CGFloat itemPaddingX = 0.0f;
    if (itemsPerRow > 1) itemPaddingX = (self.rowWidth - (self.itemSize.width * itemsPerRow)) / (itemsPerRow - 1);
    
    for (int i=0; i<itemCount; i++) {
        NSUInteger column = i % itemsPerRow;
        NSUInteger row = i / itemsPerRow;
        
//        // y-axis is flipped
//        NSUInteger row = (itemCount - 1) - (i / itemsPerRow);

        
        CGFloat originX = (self.contentInset.left + (self.itemSize.width + itemPaddingX) * column);
        originX = round(originX);
        CGFloat originY = self.contentSize.height - ((self.itemSize.height * (row + 1) + PHSGridViewMinimumPadding * row));
        
        TUIView *itemView = [self.dataSource gridView:self itemForIndex:i];
        
        itemView.frame = CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
        
        [self.items addObject:itemView];
        [self addSubview:itemView];
    }
}

@end
