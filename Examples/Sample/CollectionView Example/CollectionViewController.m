//
//  CollectionViewController.m
//  CollectionView-Example
//
//  Created by Ignacio Romero Z. on 8/11/15.
//  Copyright (c) 2015 DZN Labs. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewLayout.h"

#import "CollectionViewCell.h"
#import "CollectionReusableHeaderView.h"

static NSString *kCellViewIdentifier = @"cellIdentifier";
static NSString *kHeaderViewIdentifier = @"headerIdentifier";

static NSUInteger kSectionCount = 8;

@interface CollectionViewController ()
@end

@implementation CollectionViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:kSectionCount];
    
    for (int i = 0; i < kSectionCount; i++) {
        [items addObject:[UIImage imageNamed:@"icn_clock"]];
    }
    
    self.segmentedControl.items = items;
    self.segmentedControl.delegate = self;
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.bouncySelectionIndicator = NO;
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedControl.tintColor = [UIColor colorWithRed:42/255.0 green:178/255.0 blue:123/255.0 alpha:1.0];
    self.segmentedControl.selectionIndicatorHeight = 4.0;
    
    self.collectionView.segmentedControl = self.segmentedControl;
    self.collectionView.scrollDirection = DZNScrollDirectionVertical;
    
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:kCellViewIdentifier];
    [self.collectionView registerClass:[CollectionReusableHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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


#pragma mark - Events

- (IBAction)didChangeSegment:(id)sender
{
    // Do something
}


#pragma mark - DZNSegmentedControlDelegate Methods

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)view
{
    return UIBarPositionTop;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 10;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellViewIdentifier forIndexPath:indexPath];
    cell.tag = indexPath.row;
    
    // Random color snippet from https://gist.github.com/kylefox/1689973
    CGFloat hue = (arc4random() % 256 / 256.0);  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0) + 0.5;  //  0.5 to 1.0, away from black
    
    cell.backgroundColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CollectionReusableHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderViewIdentifier forIndexPath:indexPath];
    header.titleLabel.text = @"Section Title";
    
    return header;
}


@end
