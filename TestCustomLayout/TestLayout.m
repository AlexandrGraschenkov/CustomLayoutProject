//
//  TestLayout.m
//  TestCustomLayout
//
//  Created by Alexander on 13.10.14.
//  Copyright (c) 2014 Alexander. All rights reserved.
//

#import "TestLayout.h"

#define MINIMUM_VISIBLE_CELLS_COUNT 3

@interface TestLayout ()
{
    NSArray *layoutArr;
    CGSize currentContentSize;
    NSMutableArray *roatationArr;
}

@end

@implementation TestLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        roatationArr = [NSMutableArray new];
        for (NSInteger i = 0; i < MINIMUM_VISIBLE_CELLS_COUNT; i++) {
            float randAngle = 0.4*(arc4random() % 100) / 100.0 - 0.2;
            [roatationArr addObject:@(randAngle)];
        }
        roatationArr[0] = @0;
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    layoutArr = [self generateLayout];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return layoutArr;
}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (UICollectionViewLayoutAttributes *attrs in layoutArr) {
        if ([attrs.indexPath isEqual:indexPath]) {
            return attrs;
        }
    }
    return nil;
}

- (CGSize)collectionViewContentSize
{
    return currentContentSize;
}

- (NSArray *)generateLayout
{
    NSMutableArray *arr = [NSMutableArray new];
    NSInteger sectionCount = 1;
    if ([self.collectionView.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        sectionCount = [self.collectionView.dataSource numberOfSectionsInCollectionView:self.collectionView];
    }
    CGSize cellSize = self.cellSize;
    float collectionWidth = self.collectionView.bounds.size.width;
    float xOffset = 0;
    float yOffset = 0;
    NSInteger zIndex = 0;
    
    for (NSInteger section = 0; section < sectionCount; section++) {
        NSInteger itemsCount = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < itemsCount; item++){
            NSIndexPath *idxPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:idxPath];
            attrs.frame = CGRectMake(xOffset, yOffset, cellSize.width, cellSize.height);
            attrs.zIndex = zIndex;
            NSLog(@"%@", attrs);
            if (item < MINIMUM_VISIBLE_CELLS_COUNT) {
                float rotation = [roatationArr[item] floatValue];
                attrs.transform = CGAffineTransformMakeRotation(rotation);
                attrs.hidden = NO;
            } else {
                attrs.hidden = YES;
            }
            [arr addObject:attrs];
            zIndex++;
        }
        xOffset += cellSize.width + self.sectionSpacing.width;
        if (xOffset + cellSize.width > collectionWidth) {
            xOffset = 0;
            yOffset += cellSize.height + self.sectionSpacing.height;
        }
    }
    
    currentContentSize = CGSizeMake(xOffset, yOffset);
    return arr;
}

@end
