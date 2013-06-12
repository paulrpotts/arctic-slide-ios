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
    // SOLVE LEVEL 1
    NSLog(@"%@\n", model_p);

    // MOVE 1
    // turn E, walk E until we are adjacent to ice block (21 moves)
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    
    // walk around ice block so we're on the right of it
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_north];
    [model_p penguinMove:dir_north];

    // face west and push ice block, it should slide into tree
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    
    NSLog(@"%@\n", model_p);

    // MOVE 2
    // go push the rightmost heart up into the ice block
    // turn S, walk S
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_south];

    // turn W, walk until we're under the heart
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];

    // turn N, push the heart
    [model_p penguinMove:dir_north];
    [model_p penguinMove:dir_north];

    NSLog(@"%@\n", model_p);

    // MOVE 3
    // manuever bomb into bottom left corner by trees,
    // get around it and push it left to blow up mountain
    // next to house
    
    // turn W, walk W
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];

    // turn N, walk N until we are E of bomb
    [model_p penguinMove:dir_north];
    [model_p penguinMove:dir_north];
    [model_p penguinMove:dir_north];

    // slide bomb west into trees
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];

    // go approach it from N and push S into trees
    [model_p penguinMove:dir_north];
    [model_p penguinMove:dir_north];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];

    // push it S
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_south];

    // walk through trees to get to W of bomb, push it E,
    // it should blow up mtn next to house
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];

    NSLog(@"%@\n", model_p);

    // MOVE 4
    // knock ice block down from between two
    // hearts on left side of board
    // Get into position:

    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_north];
    [model_p penguinMove:dir_north];
    [model_p penguinMove:dir_north];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_south];

    NSLog(@"%@\n", model_p);

    // MOVE 5
    // knock middle heart left (into left heart),
    // down into ice block, then right into home
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    NSLog(@"%@\n", model_p);

    [model_p penguinMove:dir_north];
    [model_p penguinMove:dir_north];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    NSLog(@"%@\n", model_p);

    // MOVE 6
    // do the same for the rightmost heart
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_north];
    [model_p penguinMove:dir_north];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_north];
    [model_p penguinMove:dir_north];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    NSLog(@"%@\n", model_p);

    // MOVE 7 and leftmost heart
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_north];
    [model_p penguinMove:dir_north];
    [model_p penguinMove:dir_north];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_west];
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_south];
    [model_p penguinMove:dir_east];
    [model_p penguinMove:dir_east];

    NSLog(@"%@\n", model_p);

}

@end
