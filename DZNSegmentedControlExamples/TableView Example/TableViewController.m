//
//  TableViewController.m
//  Sample
//
//  Created by Ignacio Romero Z. on 1/26/15.
//  Copyright (c) 2015 DZN Labs. All rights reserved.
//

#import "TableViewController.h"

#define DEBUG_ APPERANCE    NO
#define DEBUG_IMAGE         NO

#define kBakgroundColor     [UIColor colorWithRed:0/255.0 green:87/255.0 blue:173/255.0 alpha:1.0]
#define kTintColor          [UIColor colorWithRed:20/255.0 green:200/255.0 blue:255/255.0 alpha:1.0]
#define kHairlineColor      [UIColor colorWithRed:0/255.0 green:36/255.0 blue:100/255.0 alpha:1.0]

@interface TableViewController () <DZNSegmentedControlDelegate>
@property (nonatomic, strong) DZNSegmentedControl *control;
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation TableViewController

+ (void)initialize
{
#if DEBUG_APPERANCE
    
    [[DZNSegmentedControl appearance] setBackgroundColor:kBakgroundColor];
    [[DZNSegmentedControl appearance] setTintColor:kTintColor];
    [[DZNSegmentedControl appearance] setHairlineColor:kHairlineColor];
    
    [[DZNSegmentedControl appearance] setFont:[UIFont fontWithName:@"EuphemiaUCAS" size:15.0]];
    [[DZNSegmentedControl appearance] setSelectionIndicatorHeight:2.5];
    [[DZNSegmentedControl appearance] setAnimationDuration:0.125];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor], NSFontAttributeName: [UIFont systemFontOfSize:18.0]}];
    
#endif
}

- (void)loadView
{
    [super loadView];
    
    self.title = NSStringFromClass([DZNSegmentedControl class]);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSegment:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshSegments:)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if DEBUG_IMAGE
    _menuItems = @[[UIImage imageNamed:@"icn_clock"], [UIImage imageNamed:@"icn_emoji"], [UIImage imageNamed:@"icn_gift"]];
#else
    _menuItems = @[[@"Tweets" uppercaseString], [@"Following" uppercaseString], [@"Followers" uppercaseString]];
#endif
    
    self.tableView.tableHeaderView = self.control;
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.clipsToBounds = YES;
    
    [self updateControlCounts];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (DZNSegmentedControl *)control
{
    if (!_control)
    {
        _control = [[DZNSegmentedControl alloc] initWithItems:self.menuItems];
        _control.delegate = self;
        _control.selectedSegmentIndex = 1;
        _control.bouncySelectionIndicator = NO;
        _control.height = 60.0f;
        _control.selectionIndicatorPadding = 5.0f;

        // Additional options/features
//        _control.height = 120.0f;
//        _control.width = 300.0f;
//        _control.showsGroupingSeparators = YES;
//        _control.inverseTitles = YES;
//        _control.backgroundColor = [UIColor lightGrayColor];
//        _control.tintColor = [UIColor purpleColor];
//        _control.hairlineColor = [UIColor purpleColor];
//        _control.showsCount = NO;
//        _control.autoAdjustSelectionIndicatorWidth = NO;
//        _control.selectionIndicatorHeight = 4.0;
//        _control.adjustsFontSizeToFitWidth = YES;
//        _control.selectionIndicatorPadding = 5.0;

        [_control addTarget:self action:@selector(didChangeSegment:) forControlEvents:UIControlEventValueChanged];
    }
    return _control;
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    
#if DEBUG_IMAGE
    cell.textLabel.text = [NSString stringWithFormat:@"cell #%d", (int)indexPath.row+1];
#else
    cell.textLabel.text = [NSString stringWithFormat:@"%@ #%d", [[self.control titleForSegmentAtIndex:self.control.selectedSegmentIndex] capitalizedString], (int)indexPath.row+1];
#endif
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}


#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - ViewController Methods

- (void)addSegment:(id)sender
{
    NSUInteger newSegment = self.control.numberOfSegments;
    
#if DEBUG_IMAGE
    [self.control setImage:[UIImage imageNamed:@"icn_clock"] forSegmentAtIndex:newSegment];
#else
    [self.control setTitle:[@"Favorites" uppercaseString] forSegmentAtIndex:newSegment];
    [self.control setCount:@((arc4random()%10000)) forSegmentAtIndex:newSegment];
#endif
}

- (void)refreshSegments:(id)sender
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.menuItems];
    NSUInteger count = [array count];
    
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSUInteger nElements = count - i;
        NSUInteger n = (arc4random() % nElements) + i;
        [array exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    _menuItems = array;
    
    [self.control setItems:self.menuItems];
    [self updateControlCounts];
}

- (void)updateControlCounts
{
    [self.control setCount:@((arc4random()%10000)) forSegmentAtIndex:0];
    [self.control setCount:@((arc4random()%10000)) forSegmentAtIndex:1];
    [self.control setCount:@((arc4random()%10000)) forSegmentAtIndex:2];
    
#if DEBUG_APPERANCE
    [self.control setTitleColor:kHairlineColor forState:UIControlStateNormal];
#endif
}

- (void)didChangeSegment:(DZNSegmentedControl *)control
{
    [self.tableView reloadData];
}


#pragma mark - DZNSegmentedControlDelegate Methods

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)view
{
    return UIBarPositionAny;
}

- (UIBarPosition)positionForSelectionIndicator:(id<UIBarPositioning>)bar
{
    return UIBarPositionAny;
}

@end
