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

#import "UICollectionView+SupplementaryElementScrolling.h"

static NSString *kCellViewIdentifier = @"cellIdentifier";
static NSString *kHeaderViewIdentifier = @"headerIdentifier";

static NSUInteger kSectionCount = 9;

@interface CollectionViewController () <CollectionReusableHeaderViewDelegate>
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
    self.segmentedControl.bouncySelectionIndicator = NO;
    self.segmentedControl.backgroundColor = [UIColor whiteColor];
    self.segmentedControl.tintColor = [UIColor colorWithRed:42/255.0 green:178/255.0 blue:123/255.0 alpha:1.0];
    self.segmentedControl.selectionIndicatorHeight = 4.0;
    self.segmentedControl.disableSelectedSegment = NO;
    self.segmentedControl.adjustsFontSizeToFitWidth = NO;
    self.segmentedControl.autoAdjustSelectionIndicatorWidth = NO;
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.showsCount = NO;
    
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
    NSInteger section = self.segmentedControl.selectedSegmentIndex;
    
    [self.collectionView scrollToSection:section forSupplementaryElementOfKind:UICollectionElementKindSectionHeader animated:YES];
}


#pragma mark - DZNSegmentedControlDelegate Methods

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)view
{
    return UIBarPositionBottom;
}

- (UIBarPosition)positionForSelectionIndicator:(id<UIBarPositioning>)bar
{
    return UIBarPositionTop;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return kSectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arc4random() % 100 + 20;
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
    header.titleLabel.text = [NSString stringWithFormat:@"Section Title %ld", indexPath.section+1];
    header.delegate = self;
    header.tag = indexPath.section;
    
    return header;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger section = [self.collectionView sectionForHighestSupplementaryElementOfKind:UICollectionElementKindSectionHeader];
    
    if (section != NSNotFound && (scrollView.isDecelerating || scrollView.isDragging)) {
        [self.segmentedControl setSelectedSegmentIndex:section animated:YES];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    NSUInteger section = [self.collectionView sectionForHighestSupplementaryElementOfKind:UICollectionElementKindSectionHeader];
    
    if (section != NSNotFound) {
        [self.segmentedControl setSelectedSegmentIndex:section animated:YES];
    }
}


#pragma mark - CollectionReusableHeaderViewDelegate

- (void)collectionReusableHeaderView:(CollectionReusableHeaderView *)headerView didTapHeader:(id)sender
{
    NSInteger section = headerView.tag;
    
    [self.collectionView scrollToSection:section forSupplementaryElementOfKind:UICollectionElementKindSectionHeader animated:YES];
}

@end
