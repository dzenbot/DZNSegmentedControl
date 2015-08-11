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
@property (nonatomic, strong) NSMutableArray *itemAttributes;
@property (nonatomic) CGSize contentSize;
@end

@implementation CollectionViewLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureFittingWidth:CGRectGetWidth([UIScreen mainScreen].bounds) columnCount:8];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configureFittingWidth:CGRectGetWidth([UIScreen mainScreen].bounds) columnCount:8];
    }
    return self;
}

- (void)configureFittingWidth:(CGFloat)width columnCount:(NSUInteger)columnCount
{
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.minimumInteritemSpacing = 0.0;
    self.minimumLineSpacing = 0.0;
    
    CGFloat cellHeight = roundf(width/columnCount);
    
    self.columnCount = columnCount;
    self.cellHeight = cellHeight;
    self.headerHeight = [CollectionReusableHeaderView height];
    
    self.itemSize = CGSizeMake(cellHeight, cellHeight);
    self.headerReferenceSize = CGSizeMake(width, cellHeight);
}

+ (instancetype)layoutFittingWidth:(CGFloat)width columnCount:(NSUInteger)columnCount
{
    CollectionViewLayout *layout = [CollectionViewLayout new];
    [layout configureFittingWidth:width columnCount:columnCount];
    
    return layout;
}


#pragma mark - UICollectionViewLayout Methods

//- (void)prepareLayout
//{
//    _itemAttributes = nil;
//    _itemAttributes = [[NSMutableArray alloc] init];
//    
//    NSUInteger numberOfSections = [self.collectionView numberOfSections];
//    BOOL enableHeader = (numberOfSections > 1) ? YES : NO;
//    
//    CGFloat cellHeight = self.cellHeight;
//    CGFloat headerHeight = self.headerHeight;
//    CGFloat lineSepacing = self.minimumLineSpacing;
//    NSUInteger columnCount = self.columnCount;
//    
//    CGFloat contentWidth = self.collectionView.bounds.size.width;
//    CGFloat contentHeight = 0;
//    
//    NSUInteger row = 0.0;
//    NSUInteger column = 0.0;
//    CGFloat xOffset = 0.0;
//    CGFloat yOffset = enableHeader ? headerHeight : 0.0;
//    
//    for (int sectionIndex = 0; sectionIndex < numberOfSections; sectionIndex++)
//    {
//        NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:sectionIndex];
//        
//        for (int rowIndex = 0; rowIndex < numberOfItems; rowIndex++)
//        {
//            if (rowIndex > 0 && (rowIndex%(columnCount)) == 0) {
//                row++;
//                column = 0;
//                
//                xOffset = 0;
//                yOffset += cellHeight;
//                
//                if (row > 0) yOffset+=lineSepacing;
//                column++;
//            }
//            else {
//                xOffset = cellHeight*column;
//                column++;
//            }
//            
//            CGFloat itemWidth = cellHeight;
//            if (column > 0 && column < columnCount) itemWidth = cellHeight-lineSepacing;
//            
//            // Create the actual UICollectionViewLayoutAttributes and add it to your array. We'll use this later in layoutAttributesForItemAtIndexPath:
//            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:rowIndex inSection:sectionIndex];
//            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//            itemAttributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemWidth, cellHeight));
//            [self.itemAttributes addObject:itemAttributes];
//        }
//        
//        if (enableHeader) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:sectionIndex];
//            UICollectionViewLayoutAttributes *headerAttribute = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
//            headerAttribute.frame = CGRectIntegral(CGRectMake(0, contentHeight, self.collectionView.bounds.size.width, headerHeight));
//            [self.itemAttributes addObject:headerAttribute];
//        }
//        
//        contentHeight += (cellHeight*(row+lineSepacing))+(row+lineSepacing);
//        
//        if (enableHeader) {
//            contentHeight += headerHeight-lineSepacing;
//            yOffset += headerHeight-lineSepacing;
//        }
//        
//        yOffset += cellHeight+lineSepacing;
//        xOffset = 0;
//        column = 0;
//        row = 0;
//    }
//    
////    if (contentHeight < self.collectionView.bounds.size.height) {
////        contentHeight = self.collectionView.bounds.size.height+1;
////    }
//    
//    // Return this in collectionViewContentSize
//    _contentSize = CGSizeMake(contentWidth, contentHeight);
//}
//
//- (CGSize)collectionViewContentSize
//{
//    return self.contentSize;
//}
//
//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [self.itemAttributes objectAtIndex:indexPath.row];
//}
//
//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    return [self.itemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
//        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
//    }]];
//}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
