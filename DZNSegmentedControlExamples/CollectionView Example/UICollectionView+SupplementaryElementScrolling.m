//
//  UICollectionView+SupplementaryElementScrolling.m
//  Sample
//
//  Created by Ignacio Romero Z. on 8/11/15.
//  Copyright (c) 2015 DZN Labs. All rights reserved.
//

#import "UICollectionView+SupplementaryElementScrolling.h"

@implementation UICollectionView (SupplementaryElementScrolling)

- (void)scrollToSection:(NSUInteger)section forSupplementaryElementOfKind:(NSString *)kind animated:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    
    UICollectionViewLayout *layout = (UICollectionViewLayout *)self.collectionViewLayout;
    UICollectionViewLayoutAttributes *layoutAttributes = [layout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    
    CGFloat offsetY = layoutAttributes.frame.origin.y;
    
    [self setContentOffset:CGPointMake(self.contentOffset.x, offsetY) animated:animated];
}

- (NSUInteger)sectionForHighestSupplementaryElementOfKind:(NSString *)kind;
{
    NSArray *indexPaths = [self indexPathsForVisibleItems];
    return [[indexPaths valueForKeyPath:@"@min.section"] integerValue];
}

@end
