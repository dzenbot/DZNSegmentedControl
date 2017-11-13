//
//  CollectionViewLayout.m
//  CollectionView-Example
//
//  Created by Ignacio Romero Z. on 8/11/15.
//  Copyright (c) 2015 DZN Labs. All rights reserved.
//

#import "CollectionViewLayout.h"
#import "CollectionReusableHeaderView.h"

@interface CollectionViewLayout ()
@end

@implementation CollectionViewLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureFittingWidth:CGRectGetWidth([UIScreen mainScreen].bounds) columnCount:7];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureFittingWidth:CGRectGetWidth([UIScreen mainScreen].bounds) columnCount:7];
    }
    return self;
}

- (void)configureFittingWidth:(CGFloat)width columnCount:(NSUInteger)columnCount
{
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.minimumInteritemSpacing = 0.0;
    self.minimumLineSpacing = 0.0;
    
    CGFloat cellHeight = width/columnCount;
    
    self.itemSize = CGSizeMake(cellHeight, cellHeight);
    self.headerReferenceSize = CGSizeMake(width, cellHeight);
}

+ (instancetype)layoutFittingWidth:(CGFloat)width columnCount:(NSUInteger)columnCount
{
    CollectionViewLayout *layout = [CollectionViewLayout new];
    [layout configureFittingWidth:width columnCount:columnCount];
    
    return layout;
}


#pragma mark - UICollectionViewLayout UISubclassingHooks Methods

- (void)prepareLayout
{
    [super prepareLayout];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *visibleLayoutAttributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    UICollectionView * const cv = self.collectionView;
    CGPoint const contentOffset = cv.contentOffset;
    
    NSMutableIndexSet *missingSections = [NSMutableIndexSet indexSet];
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in visibleLayoutAttributes) {
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            [missingSections addIndex:layoutAttributes.indexPath.section];
        }
    }
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in visibleLayoutAttributes) {
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [missingSections removeIndex:layoutAttributes.indexPath.section];
        }
    }
    
    [missingSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        
        [visibleLayoutAttributes addObject:layoutAttributes];
    }];
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in visibleLayoutAttributes) {
        
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            
            NSInteger section = layoutAttributes.indexPath.section;
            NSInteger numberOfItemsInSection = [cv numberOfItemsInSection:section];
            
            NSIndexPath *firstObjectIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            NSIndexPath *lastObjectIndexPath = [NSIndexPath indexPathForItem:MAX(0, (numberOfItemsInSection - 1)) inSection:section];
            
            BOOL isCell = NO;
            
            UICollectionViewLayoutAttributes *firstObjectAttrs;
            UICollectionViewLayoutAttributes *lastObjectAttrs;
            
            if (numberOfItemsInSection > 0) {
                // use cell data if items exist
                isCell = YES;
                firstObjectAttrs = [self layoutAttributesForItemAtIndexPath:firstObjectIndexPath];
                lastObjectAttrs = [self layoutAttributesForItemAtIndexPath:lastObjectIndexPath];
            }
            else {
                // else use the header and footer
                firstObjectAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:firstObjectIndexPath];
                lastObjectAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:lastObjectIndexPath];
            }
            
            CGFloat topHeaderHeight = (isCell) ? CGRectGetHeight(layoutAttributes.frame) : 0.0;
            CGFloat bottomHeaderHeight = CGRectGetHeight(layoutAttributes.frame);
            CGRect frameWithEdgeInsets = UIEdgeInsetsInsetRect(layoutAttributes.frame,
                                                               cv.contentInset);
            
            CGPoint origin = frameWithEdgeInsets.origin;
            
            origin.y = MIN(MAX(contentOffset.y + cv.contentInset.top, (CGRectGetMinY(firstObjectAttrs.frame) - topHeaderHeight)),
                           (CGRectGetMaxY(lastObjectAttrs.frame) - bottomHeaderHeight));
            
            layoutAttributes.zIndex = 1024;
            layoutAttributes.frame = (CGRect){
                .origin = origin,
                .size = layoutAttributes.frame.size
            };
        }
    }
    
    return visibleLayoutAttributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
