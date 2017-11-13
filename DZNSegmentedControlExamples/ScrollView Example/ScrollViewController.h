//
//  ScrollViewController.h
//  Sample
//
//  Created by Wenchao Ding on 1/24/15.
//  Copyright (c) 2015 DZN Labs. All rights reserved.
//

@import UIKit;
@import DZNSegmentedControl;

@interface ScrollViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet DZNSegmentedControl *segmentedControl;

- (IBAction)didChangeSegment:(id)sender;

@end
