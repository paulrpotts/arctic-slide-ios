//
//  ArcticSlideModel.m
//  ArcticSlide
//
//  Created by Paul R. Potts on 6/4/13.
//  Copyright (c) 2013 Paul R. Potts. All rights reserved.
//

#import "ArcticSlideModel.h"

// Get one up and running first
static const int num_polar_levels = 1;
static const int polar_data_len = 96;
static const int polar_data_num_tile_vals = 7; // 0-6 inclusive
static const int polar_data_max_tile_val = 6;
// static const NSString *polar_levels[num_polar_levels] =
// {
//    @"100000000000000100000400" \
//    @"106020545000000000100100" \
//    @"100000000000000050002300" \
//    @"110000100000000000000000"
// };

static const char *polar_levels[num_polar_levels] =
{
    "100000000000000100000400"
    "106020545000000000100100"
    "100000000000000050002300"
    "110000100000000000000000"
};

@implementation ArcticSlideTile
{
}
@end

@implementation ArcticSlideTileStateless
{
}
@end

@implementation ArcticSlideBomb
- (NSString*) description
{
    return @"Bomb";
}
@end

@implementation ArcticSlideEmpty
- (NSString*) description
{
    return @"Empty";
}
@end

@implementation ArcticSlideHeart
- (NSString*) description
{
    return @"Heart";
}
@end

@implementation ArcticSlideHouse
- (NSString*) description
{
    return @"House";
}
@end

@implementation ArcticSlideIceBlock
- (NSString*) description
{
    return @"Ice Block";
}
@end

@implementation ArcticSlideMountain
- (NSString*) description
{
    return @"Mountain";
}
@end

@implementation ArcticSlidePenguin
- (NSString*) description
{
    return @"Mountain";
}
@end

@implementation ArcticSlideTree
- (NSString*) description
{
    return @"Tree";
}
@end

@implementation ArcticSlideModel
{
    ArcticSlideBomb* bomb;
    ArcticSlideEmpty* empty;
    ArcticSlideHeart* heart;
    ArcticSlideHouse* house;
    ArcticSlideIceBlock* ice_block;
    ArcticSlideMountain* mountain;
    ArcticSlidePenguin* penguin;
    ArcticSlideTree* tree;
}

- (id)init
{
    bomb = [[ArcticSlideBomb alloc] init];
    empty = [[ArcticSlideEmpty alloc] init];
    heart = [[ArcticSlideHeart alloc] init];
    house = [[ArcticSlideHouse alloc] init];
    ice_block = [[ArcticSlideIceBlock alloc] init];
    mountain = [[ArcticSlideMountain alloc] init];
    penguin = [[ArcticSlidePenguin alloc] init];
    tree = [[ArcticSlideTree alloc] init];

    for ( unsigned int idx_y = 0;
         idx_y < board_height; idx_y++ )
    {
        for ( unsigned int idx_x = 0;
             idx_x < board_width; idx_x++ )
        {
            board[idx_y][idx_x] = empty;
        }
    }
    return self;
}

- (id)initWithLevelIndex:(int)level_idx
{
    // Call our own basic initializer. This will result in redundant
    // setting of board values, but maybe I will clean that up
    // later.
    self = [self init];

    // A simple lookup table to decode the original Polar resource
    // data as strings
    ArcticSlideTile *polar_data_tile_map[polar_data_num_tile_vals] = {
        empty, tree, mountain, house, ice_block, heart, bomb };

    if ( level_idx > ( num_polar_levels - 1) )
    {
        NSLog(@"initWithLevelLayout: received level_idx out of range!\n");
        self = nil;
    }
    else
    {
//        const NSString* level_str = polar_levels[level_idx];
//        unsigned int level_data_idx = 0;
//        for ( unsigned int idx_y = 0;
//             idx_y < board_height; idx_y++ )
//        {
//            for ( unsigned int idx_x = 0;
//                 idx_x < board_width; idx_x++ )
//            {
//                NSRange range = NSMakeRange(level_data_idx, 1);
//                const NSString * item_str = [level_str substringWithRange: range];
//                int polar_data_tile_val = [item_str intValue];
//                if ( polar_data_tile_val > polar_data_max_tile_val )
//                {
//                    NSLog(@"polar data tile value %d out of range!\n", polar_data_tile_val );
//                    self = nil;
//                }
//                else
//                {
//                    board[idx_y][idx_x] = polar_data_tile_map[polar_data_tile_val];
//                    level_data_idx++;
//                }
//            }
//        }

        const char *level_str_p = polar_levels[level_idx];
        unsigned int level_data_idx = 0;
        for ( unsigned int idx_y = 0;
             idx_y < board_height; idx_y++ )
        {
            for ( unsigned int idx_x = 0;
                 idx_x < board_width; idx_x++ )
            {
                int polar_data_tile_val = level_str_p[level_data_idx] - '0';
                if ( ( polar_data_tile_val < 0 ) || ( polar_data_tile_val > polar_data_max_tile_val ) )
                {
                    NSLog(@"polar data tile value %d out of range!\n", polar_data_tile_val );
                    self = nil;
                }
                else
                {
                    board[idx_y][idx_x] = polar_data_tile_map[polar_data_tile_val];
                    level_data_idx++;
                }
            }
        }
    }

    return self;

}

- (NSString*)description
{
    NSMutableString *desc_str =[[NSMutableString alloc]init];
    
    [desc_str appendString:@"ArcticSlideModel board state:\n"];
    for ( unsigned int idx_y = 0;
         idx_y < board_height; idx_y++ )
    {
        for ( unsigned int idx_x = 0;
             idx_x < board_width; idx_x++ )
        {
            if ( nil == board[idx_y][idx_x] )
            {
                NSLog(@"found nil at %d, %d\n", idx_y, idx_x);
            }
            [desc_str
             appendString:[board[idx_y][idx_x] description]];
            [desc_str appendString:@" "];
        }
        [desc_str appendString:@"\n"];
    }
    return desc_str;
}

@end
