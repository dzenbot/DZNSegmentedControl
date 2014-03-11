//
//  ViewController.m
//  Sample
//
//  Created by Ignacio Romero Zurbuchen on 3/4/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//

#import "ViewController.h"
#import "DZNSegmentedControl.h"

@interface ViewController () <DZNSegmentedControlDelegate> {
    DZNSegmentedControl *segmentedControl;
}
@end

@implementation ViewController

- (void)loadView
{
    [super loadView];
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [segmentedControl setCount:@((arc4random() % 300)) forSegmentAtIndex:0];
    [segmentedControl setCount:@((arc4random() % 300)) forSegmentAtIndex:1];
    [segmentedControl setCount:@((arc4random() % 300)) forSegmentAtIndex:2];
    
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %d", indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *contentView = [UIView new];
    
    NSArray *items = @[[@"Tweets" uppercaseString], [@"Following" uppercaseString], [@"Followers" uppercaseString]];
    
    segmentedControl = [[DZNSegmentedControl alloc] initWithItems:items];
    segmentedControl.tintColor = [UIColor colorWithRed:85/255.0 green:172/255.0 blue:239/255.0 alpha:1.0];
    segmentedControl.delegate = self;
    segmentedControl.selectedSegmentIndex = 1;
    
    [segmentedControl addTarget:self action:@selector(selectedSegment:) forControlEvents:UIControlEventValueChanged];
    [contentView addSubview:segmentedControl];
    
    return contentView;
}


#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)selectedSegment:(DZNSegmentedControl *)control
{
    NSLog(@"%s : %d",__FUNCTION__, control.selectedSegmentIndex);
}


#pragma mark - UIBarPositioningDelegate Methods

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)view
{
    return UIBarPositionBottom;
}

@end
