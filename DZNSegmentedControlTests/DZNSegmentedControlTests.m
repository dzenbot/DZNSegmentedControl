//
//  DZNSegmentedControlTests.m
//  DZNSegmentedControlTests
//
//  Created by Ignacio Romero on 2017-11-13.
//  Copyright © 2017 DZN Labs. All rights reserved.
//

@import XCTest;
@import DZNSegmentedControl;

@interface DZNSegmentedControlTests : XCTestCase
@end

@implementation DZNSegmentedControlTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSegmentedControlInitialization
{
    NSArray *items = @[@"description", @"ingredients", @"instructions", @"gallery"];

    DZNSegmentedControl *control = [[DZNSegmentedControl alloc] initWithItems:items];

    XCTAssertNotNil(control);
    XCTAssertTrue([control.items isEqualToArray:items]);
}

@end
