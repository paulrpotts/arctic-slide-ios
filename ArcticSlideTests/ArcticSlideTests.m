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
    // ArcticSlideModel *model = [[ArcticSlideModel alloc] init];
    // NSLog(@"%@", model);

    model_p = [ArcticSlideModel getModel];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    NSLog(@"%@\n", model_p);
    // Penguin starts at 0,0, on top of a tree
    pos_t penguin_pos = { 0, 0 };

    // Walk the penguin south onto another tree tile
    ArcticSlideTile* tile_p =
    [model_p getTileFromPosition:penguin_pos inDirection:dir_south];
    NSLog(@"Penguin is facing: %@\n", tile_p);
    BOOL allowed = [tile_p pushFromPosition:penguin_pos
                                inDirection:dir_south];
    NSLog(@"Penguin allowed: %s\n", ( allowed ? "YES" : "NO" ) );
    tile_p = [model_p getTileFromPosition:penguin_pos
                              inDirection:dir_south];
    penguin_pos = getUpdatedPos(penguin_pos, dir_south);
    NSLog(@"Penguin is facing: %@\n", tile_p);
    
    // Walk the penguin east onto an empty space
    tile_p = [model_p getTileFromPosition:penguin_pos
                              inDirection:dir_east];
    NSLog(@"Penguin is facing: %@\n", tile_p);
    allowed = [tile_p pushFromPosition:penguin_pos
                           inDirection:dir_east];
    NSLog(@"Penguin allowed: %s\n", ( allowed ? "YES" : "NO" ) );
    tile_p = [model_p getTileFromPosition:penguin_pos
                              inDirection:dir_east];
    penguin_pos = getUpdatedPos(penguin_pos, dir_east);

    // Try walking into a bomb, which should slide
    // and blow up a mountain
    tile_p = [model_p getTileFromPosition:penguin_pos
                              inDirection:dir_east];
    NSLog(@"Penguin is facing: %@\n", tile_p);
    allowed = [tile_p pushFromPosition:penguin_pos
                           inDirection:dir_east];
    NSLog(@"Penguin allowed: %s\n", ( allowed ? "YES" : "NO" ) );

    NSLog(@"%@\n", model_p);

    // Bomb should be gone, we can walk all the way to heart
    tile_p = [model_p getTileFromPosition:penguin_pos inDirection:dir_east];
    NSLog(@"Penguin is facing: %@\n", tile_p);
    allowed = [tile_p pushFromPosition:penguin_pos inDirection:dir_east];
    NSLog(@"Penguin allowed: %s\n", ( allowed ? "YES" : "NO" ) );
    tile_p = [model_p getTileFromPosition:penguin_pos inDirection:dir_east];
    penguin_pos = getUpdatedPos(penguin_pos, dir_east);

    tile_p = [model_p getTileFromPosition:penguin_pos inDirection:dir_east];
    NSLog(@"Penguin is facing: %@\n", tile_p);
    allowed = [tile_p pushFromPosition:penguin_pos inDirection:dir_east];
    NSLog(@"Penguin allowed: %s\n", ( allowed ? "YES" : "NO" ) );
    tile_p = [model_p getTileFromPosition:penguin_pos inDirection:dir_east];
    penguin_pos = getUpdatedPos(penguin_pos, dir_east);

    tile_p = [model_p getTileFromPosition:penguin_pos inDirection:dir_east];
    NSLog(@"Penguin is facing: %@\n", tile_p);
    allowed = [tile_p pushFromPosition:penguin_pos inDirection:dir_east];
    NSLog(@"Penguin allowed: %s\n", ( allowed ? "YES" : "NO" ) );
    tile_p = [model_p getTileFromPosition:penguin_pos inDirection:dir_east];
    penguin_pos = getUpdatedPos(penguin_pos, dir_east);

    tile_p = [model_p getTileFromPosition:penguin_pos inDirection:dir_east];
    NSLog(@"Penguin is facing: %@\n", tile_p);
    allowed = [tile_p pushFromPosition:penguin_pos inDirection:dir_east];
    NSLog(@"Penguin allowed: %s\n", ( allowed ? "YES" : "NO" ) );
    tile_p = [model_p getTileFromPosition:penguin_pos inDirection:dir_east];
    penguin_pos = getUpdatedPos(penguin_pos, dir_east);

    // Next to a heart
    tile_p = [model_p getTileFromPosition:penguin_pos inDirection:dir_east];
    NSLog(@"Penguin is facing: %@\n", tile_p);
    allowed = [tile_p pushFromPosition:penguin_pos inDirection:dir_east];
    NSLog(@"Penguin allowed: %s\n", ( allowed ? "YES" : "NO" ) );
    tile_p = [model_p getTileFromPosition:penguin_pos inDirection:dir_east];
    penguin_pos = getUpdatedPos(penguin_pos, dir_east);

}

@end
