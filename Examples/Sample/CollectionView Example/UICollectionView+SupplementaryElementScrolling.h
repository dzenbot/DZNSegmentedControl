//
//  UICollectionView+SupplementaryElementScrolling.h
//  Sample
//
//  Created by Ignacio Romero Z. on 8/11/15.
//  Copyright (c) 2015 DZN Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (SupplementaryElementScrolling)

- (void)scrollToSection:(NSUInteger)section forSupplementaryElementOfKind:(NSString *)kind animated:(BOOL)animated;

- (NSUInteger)sectionForHighestSupplementaryElementOfKind:(NSString *)kind;

@end
