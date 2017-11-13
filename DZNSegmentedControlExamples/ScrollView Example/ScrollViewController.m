//
//  ScrollViewController.m
//  Sample
//
//  Created by Wenchao Ding on 1/24/15.
//  Copyright (c) 2015 DZN Labs. All rights reserved.
//

#import "ScrollViewController.h"

@interface ScrollViewController () <DZNSegmentedControlDelegate>
@end

@implementation ScrollViewController

#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    
    self.title = NSStringFromClass([DZNSegmentedControl class]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.segmentedControl.items = @[@"Page #1", @"Page #2", @"Page #3"];
    self.segmentedControl.showsCount = NO;
    self.segmentedControl.autoAdjustSelectionIndicatorWidth = YES;
    self.segmentedControl.height = 30;
    self.segmentedControl.delegate = self;

    self.scrollView.segmentedControl = self.segmentedControl;
    self.scrollView.scrollDirection = DZNScrollDirectionHorizontal;
    self.scrollView.scrollOnSegmentChange = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.clipsToBounds = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.scrollView.frame = [UIScreen mainScreen].bounds;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    __block CGFloat offsetValue = 0.0;
    __block CGSize contentSize = CGSizeZero;

    if (self.scrollView.scrollDirection == DZNScrollDirectionHorizontal) {
        [self.segmentedControl.items enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
            CGRect frame = [UIScreen mainScreen].bounds;
            frame.origin.x = offsetValue;
            
            [self addLabel:idx withFrame:frame];
            
            offsetValue += CGRectGetWidth(frame);
        }];
        
        contentSize = CGSizeMake(offsetValue, self.scrollView.frame.size.height);
    }
    else {
        [self.segmentedControl.items enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
            CGRect frame = [UIScreen mainScreen].bounds;
            frame.origin.y = offsetValue;
            
            [self addLabel:idx withFrame:frame];
            
            offsetValue += CGRectGetHeight(frame);
        }];
        
        contentSize = CGSizeMake(self.scrollView.frame.size.width, offsetValue);
    }
    
    self.scrollView.contentSize = contentSize;
}

- (void)addLabel:(NSInteger)idx withFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    label.backgroundColor = (idx%2 == 0) ? [UIColor redColor] : [UIColor blueColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:40];
    label.text = self.segmentedControl.items[idx];
    
    [self.scrollView addSubview:label];
}


#pragma mark - Events

- (IBAction)didChangeSegment:(id)sender
{
    NSLog(@"%s",__FUNCTION__);
}


#pragma mark - DZNSegmentedControlDelegate Methods

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)view
{
    return UIBarPositionTop;
}

- (UIBarPosition)positionForSelectionIndicator:(id<UIBarPositioning>)bar
{
    return UIBarPositionBottom;
}


#pragma mark - View Auto-Rotation

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}


#pragma mark - View lifeterm

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    
}

@end
