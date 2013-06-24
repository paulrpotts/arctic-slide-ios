//
//  ArcticSlideTests.m
//  ArcticSlideTests
//
//  Created by Paul R. Potts on 6/4/13.
//  Copyright (c) 2013 Paul R. Potts. All rights reserved.
//

#import "ArcticSlideTests.h"

@implementation ArcticSlideTests

static ArcticSlideModel *model_p;

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    model_p = [[ArcticSlideModel alloc] initWithLevelIndex:0];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    NSLog(@"%@\n", model_p);

    [model_p penguinMoveNTimes:21 due:dir_east];
    [model_p penguinMoveNTimes:2 due:dir_south];
    [model_p penguinMoveNTimes:3 due:dir_east];
    [model_p penguinMoveNTimes:2 due:dir_north];
    [model_p penguinMoveNTimes:2 due:dir_west];

    NSLog(@"%@\n", model_p);

    [model_p penguinMoveNTimes:4 due:dir_south];
    [model_p penguinMoveNTimes:7 due:dir_west];
    [model_p penguinMoveNTimes:2 due:dir_north];

    NSLog(@"%@\n", model_p);

    [model_p penguinMoveNTimes:14 due:dir_west];
    [model_p penguinMoveNTimes:3 due:dir_north];
    [model_p penguinMoveNTimes:2 due:dir_west];
    [model_p penguinMoveNTimes:2 due:dir_north];
    [model_p penguinMoveNTimes:3 due:dir_west];
    [model_p penguinMoveNTimes:2 due:dir_south];
    [model_p penguinMoveNTimes:2 due:dir_west];
    [model_p penguinMoveNTimes:3 due:dir_south];
    [model_p penguinMoveNTimes:2 due:dir_east];

    NSLog(@"%@\n", model_p);

    [model_p penguinMoveNTimes:5 due:dir_east];
    [model_p penguinMoveNTimes:3 due:dir_north];
    [model_p penguinMoveNTimes:3 due:dir_east];
    [model_p penguinMoveNTimes:2 due:dir_south];

    NSLog(@"%@\n", model_p);

    [model_p penguinMoveNTimes:3 due:dir_east];
    [model_p penguinMoveNTimes:2 due:dir_south];
    [model_p penguinMoveNTimes:2 due:dir_west];
    [model_p penguinMoveNTimes:2 due:dir_north];
    [model_p penguinMoveNTimes:3 due:dir_west];
    [model_p penguinMoveNTimes:2 due:dir_south];
    [model_p penguinMoveNTimes:3 due:dir_west];
    [model_p penguinMoveNTimes:3 due:dir_south];
    [model_p penguinMoveNTimes:3 due:dir_east];

    NSLog(@"%@\n", model_p);

    [model_p penguinMoveNTimes:11 due:dir_east];
    [model_p penguinMoveNTimes:2 due:dir_north];
    [model_p penguinMoveNTimes:11 due:dir_west];
    [model_p penguinMoveNTimes:2 due:dir_north];
    [model_p penguinMoveNTimes:2 due:dir_west];
    [model_p penguinMoveNTimes:2 due:dir_south];
    [model_p penguinMoveNTimes:3 due:dir_west];
    [model_p penguinMoveNTimes:3 due:dir_south];
    [model_p penguinMoveNTimes:3 due:dir_east];

    NSLog(@"%@\n", model_p);

    [model_p penguinMoveNTimes:2 due:dir_west];
    [model_p penguinMoveNTimes:3 due:dir_north];
    [model_p penguinMoveNTimes:2 due:dir_east];
    [model_p penguinMoveNTimes:2 due:dir_south];
    [model_p penguinMoveNTimes:2 due:dir_west];
    [model_p penguinMoveNTimes:3 due:dir_south];
    [model_p penguinMoveNTimes:2 due:dir_east];
    
    NSLog(@"%@\n", model_p);

}

@end
