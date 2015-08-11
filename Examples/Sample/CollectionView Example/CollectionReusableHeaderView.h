//
//  CollectionReusableHeaderView.h
//  CollectionView-Example
//
//  Created by Ignacio Romero Z. on 8/11/15.
//  Copyright (c) 2015 DZN Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionReusableHeaderView : UICollectionReusableView

@property (nonatomic, strong) UILabel *titleLabel;

+ (CGFloat)height;

@end
