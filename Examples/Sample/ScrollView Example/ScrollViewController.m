//
//  ScrollViewController.m
//  Sample
//
//  Created by Wenchao Ding on 1/24/15.
//  Copyright (c) 2015 DZN Labs. All rights reserved.
//

#import "ScrollViewController.h"
#import "DZNSegmentedControl.h"
#import "UIScrollView+DZNSegmentedControl.h"

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
    self.segmentedControl.autoAdjustSelectionIndicatorWidth = NO;
    
    self.scrollView.segmentedControl = self.segmentedControl;
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
    
    __block CGFloat originX = 0.0;
    
    [self.segmentedControl.items enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.origin.x = originX;
        
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        label.backgroundColor = (idx%2 == 0) ? [UIColor redColor] : [UIColor blueColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:40];
        label.text = name;
        
        [self.scrollView addSubview:label];
        
        originX += CGRectGetWidth(frame);
    }];
    
    self.scrollView.contentSize = CGSizeMake(originX, self.scrollView.frame.size.height);
}


#pragma mark - Events

- (IBAction)didChangeSegment:(id)sender
{
    NSLog(@"%s",__FUNCTION__);
}


#pragma mark - View Auto-Rotation

- (NSUInteger)supportedInterfaceOrientations
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
