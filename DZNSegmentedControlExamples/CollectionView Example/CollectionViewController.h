//
//  CollectionViewController.h
//  CollectionView-Example
//
//  Created by Ignacio Romero Z. on 8/11/15.
//  Copyright (c) 2015 DZN Labs. All rights reserved.
//

@import UIKit;
@import DZNSegmentedControl;

@interface CollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, DZNSegmentedControlDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet DZNSegmentedControl *segmentedControl;

- (IBAction)didChangeSegment:(id)sender;

@end

