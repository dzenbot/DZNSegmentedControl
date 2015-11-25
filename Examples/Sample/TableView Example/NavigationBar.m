//
//  NavigationBar.m
//  Sample
//
//  Created by Ignacio Romero on 11/25/15.
//  Copyright © 2015 DZN Labs. All rights reserved.
//

#import "NavigationBar.h"

@implementation NavigationBar

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];

        [self addSubview:self.segmentedControl];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    // Removes the native hairline
    [self setShadowImage:[UIImage new]];
    [self setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    self.transform = CGAffineTransformMakeTranslation(0.0, -([self incrementedHeight]));
}

- (DZNSegmentedControl *)segmentedControl
{
    if (!_segmentedControl) {
        _segmentedControl = [[DZNSegmentedControl alloc] initWithFrame:CGRectMake(0.0, CGRectGetHeight(self.bounds), 0.0, 0.0)];
        _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _segmentedControl.backgroundColor = [UIColor clearColor];
        _segmentedControl.selectedSegmentIndex = 1;
        _segmentedControl.bouncySelectionIndicator = NO;
        _segmentedControl.height = 60.0f;
    }
    return _segmentedControl;
}

- (CGFloat)incrementedHeight
{
    return self.segmentedControl.intrinsicContentSize.height;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize amendedSize = [super sizeThatFits:size];
    
    if (_segmentedControl) {
        amendedSize.height += [self incrementedHeight];
    }
    
    return amendedSize;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSArray *classNamesToReposition = @[@"_UINavigationBarBackground"];
    
    for (UIView *view in [self subviews]) {
        
        if ([classNamesToReposition containsObject:NSStringFromClass([view class])]) {
            
            CGRect frame = [self bounds];
            if (_segmentedControl) {
                frame.size.height += [self incrementedHeight];
            }
            
            view.frame = frame;
        }
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    
    CGPoint viewPoint = [self.segmentedControl convertPoint:point fromView:self];
    
    if ([self.segmentedControl pointInside:viewPoint withEvent:event]) {
        inside = YES;
    }
    
    return inside;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    
    CGPoint viewPoint = [self.segmentedControl convertPoint:point fromView:self];
    
    if ([self.segmentedControl pointInside:viewPoint withEvent:event]) {
        view = self.segmentedControl;
    }
    
    return view;
}

@end
