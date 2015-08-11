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
    UICollectionViewLayout *layout = (UICollectionViewLayout *)self.collectionViewLayout;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];

    UICollectionViewLayoutAttributes *layoutAttributes = [layout layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
    
    CGFloat offsetY = layoutAttributes.frame.origin.y;
    
    CGFloat contentInsetY = self.contentInset.top;
    CGFloat sectionInsetY = ((UICollectionViewFlowLayout *)self.collectionViewLayout).sectionInset.top;
    
    [self setContentOffset:CGPointMake(self.contentOffset.x, offsetY - contentInsetY - sectionInsetY) animated:animated];
}

- (NSUInteger)sectionForVisibleSupplementaryElementOfKind:(NSString *)kind;
{
    NSArray *indexPaths = [self indexPathsForVisibleItems];
    
    if (indexPaths.count == 0) {
        return NSNotFound;
    }
    
    return [[indexPaths valueForKeyPath:@"@min.section"] integerValue];
}

@end
