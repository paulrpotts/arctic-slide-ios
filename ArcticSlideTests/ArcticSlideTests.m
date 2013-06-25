//
//  ArcticSlideTests.m
//  ArcticSlideTests
//
//  Created by Paul R. Potts on 6/4/13.
//
// Width guides for code to be formatted for Blogger: 67 chars for 860 px,
// (my previous template), 80 chars for 960 px (my current template).
//
//34567890123456789012345678901234567890123456789012345678901234567
//345678901234567890123456789012345678901234567890123456789012345678901234567890

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
