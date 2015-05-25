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

@class DZNSegmentedControl;

@interface UIScrollView (DZNSegmentedControl)

@property (nonatomic, weak) DZNSegmentedControl *segmentedControl;

@end
