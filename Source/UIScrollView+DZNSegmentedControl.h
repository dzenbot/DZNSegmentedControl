//
//  UIScrollView+DZNSegmentedControl.h
//  DZNSegmentedControl
//  https://github.com/dzenbot/DZNSegmentedControl
//
//  Created by Ignacio Romero Zurbuchen on 1/26/15.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DZNScrollDirection) {
    DZNScrollDirectionHorizontal,
    DZNScrollDirectionVertical
};

@class DZNSegmentedControl;

@interface UIScrollView (DZNSegmentedControl)

/** The scrolling direction of the scrollView. Default is Horizontal. */
@property (nonatomic) DZNScrollDirection scrollDirection;

/** YES if the scrollview should scroll automatically when a segment changes. Default is YES. */
@property (nonatomic) BOOL scrollOnSegmentChange;

/** The scrollView reference to observe the content offset updates and interact with. */
@property (nonatomic, weak) DZNSegmentedControl *segmentedControl;

@end
