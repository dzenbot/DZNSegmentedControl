//
//  UIScrollView+DZNSegmentedControl.m
//  DZNSegmentedControl
//  https://github.com/dzenbot/DZNSegmentedControl
//
//  Created by Ignacio Romero Zurbuchen on 1/26/15.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import "UIScrollView+DZNSegmentedControl.h"
#import "DZNSegmentedControl.h"
#import <objc/runtime.h>

const char * segmentedControlKey;
const char * observerContext;

static NSString *contentOffsetKey = @"contentOffset";

@implementation UIScrollView (DZNSegmentedControl)


#pragma mark - Getters

- (DZNSegmentedControl *)segmentedControl
{
    return objc_getAssociatedObject(self, &segmentedControlKey);
}


#pragma mark - Setters

- (void)setSegmentedControl:(DZNSegmentedControl *)segmentedControl
{
    objc_setAssociatedObject(self, &segmentedControlKey, segmentedControl, OBJC_ASSOCIATION_ASSIGN);
    
    if (segmentedControl) {
        [self addObserver:self forKeyPath:contentOffsetKey options:NSKeyValueObservingOptionNew context:&observerContext];
        [segmentedControl addTarget:self action:@selector(dzn_didChangeSegement:) forControlEvents:UIControlEventValueChanged];
    }
    else if (self.segmentedControl) {
        [self removeObserver:self forKeyPath:contentOffsetKey context:&observerContext];
        [segmentedControl removeTarget:self action:@selector(dzn_didChangeSegement:) forControlEvents:UIControlEventValueChanged];
    }
}


#pragma mark - Events

- (void)dzn_didChangeSegement:(id)sender
{
    NSInteger index = self.segmentedControl.selectedSegmentIndex;
    CGFloat pageWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    
    [self setContentOffset:CGPointMake(pageWidth*index, 0.0) animated:YES];
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:contentOffsetKey] && context == &observerContext && self.pagingEnabled)
    {
        CGPoint contentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
        
        if (self.isDragging || self.isDecelerating) {
            self.segmentedControl.scrollOffset = contentOffset;
        }
    }
}

@end
