//
//  ArcticSlideModel.m
//  ArcticSlide
//
//  Created by Paul R. Potts on 6/4/13.
//  Copyright (c) 2013 Paul R. Potts. All rights reserved.
//

#import "ArcticSlideModel.h"
#import "PolarBoards.h"

@implementation ArcticSlideTile
{
}

// These versions in the base class should not be called; all instantiated
// tile objects should have either overriden them or should have not been
// send these messages.
- (BOOL)push:(pos_t)fromPosition :(dir_e)inDirection
{
    NSLog(@"ArcticSlideTile slide method called!\n");
    // Don't let the penguin move onto this space
    return NO;
}

- (BOOL)slide:(pos_t)fromPosition :(dir_e)inDirection
{
    NSLog(@"ArcticSlideTile slide method called!\n");
    // Don't let the piece keep moving
    return NO;
}

@end

@implementation ArcticSlideBomb

- (BOOL)push:(pos_t)fromPosition :(dir_e)inDirection
{
    ArcticSlideTile *tile = [model getTile:fromPosition:inDirection];
    if ( nil == tile )
    {
        // there is nothing there -- we're pushing against
        // the edge of the world. queue a fail beep
    }
    if ( [model getMountain] == tile )
    {
        // bomb pushed into mountain
        // animate bomb moving onto mountain
        // animate explosion
        // remove both bomb and mountain from board, update
        // mountain tile
    }
    else if ( [model getEmpty] == tile )
    {
        // animate bomb moving into space
        // remove from old pos
        // insert at new pos
    }
    // The penguin cannot actually move onto the position this round
    return NO;
}

- (BOOL)slide:(pos_t)fromPosition :(dir_e)inDirection
{
    ArcticSlideTile *tile = [model getTile:fromPosition:inDirection];
    if ( [model getEmpty] == tile )
    {
        // we can move onto this tile -- update the model with
        // the new position
        // return YES to indicate that we are still sliding
        // and slide should be called again
        return YES;
    }
    else
    {
        if ( [model getMountain] == tile )
        {
            // bomb pushed into mountain
            // animate bomb moving onto mountain
            // animate explosion
            // remove both bomb and mountain from board, update
            // mountain tile
        }
        // Bomb is done sliding
        return NO;
    }
}

- (NSString*) description
{
    return @"Bomb";
}

@end

@implementation ArcticSlideEmpty
- (BOOL)push:(pos_t)fromPosition :(dir_e)inDirection
{
    // If the penguin pushes onto an empty tile, he can always
    // move there
    return YES;
}

- (NSString*) description
{
    return @"Empty";
}
@end

@implementation ArcticSlideHeart

- (BOOL)push:(pos_t)fromPosition :(dir_e)inDirection
{
    ArcticSlideTile *tile = [model getTile:fromPosition:inDirection];
    if ( nil == tile )
    {
        // there is nothing there -- we're pushing against
        // the edge of the world. queue a fail beep
    }
    else if ( [model getHouse] == tile )
    {
        // heart pushed into home
        // animate heart moving onto home
        // happy sound, score goes up
        // remove heart, update heart tile
    }
    else if ( [model getEmpty] == tile )
    {
        // animate bomb moving into space
        // remove from old pos
        // insert at new pos
    }
    // The penguin cannot actually move onto the position this round
    return NO;
}

- (BOOL)slide:(pos_t)fromPosition :(dir_e)inDirection
{
    ArcticSlideTile *tile = [model getTile:fromPosition:inDirection];
    if ( [model getEmpty] == tile )
    {
        // we can move onto this tile -- update the model with
        // the new position
        // return YES to indicate that we are still sliding
        // and slide should be called again
        return YES;
    }
    else
    {
        if ( [model getHouse] == tile )
        {
            // heart pushed into home
            // animate heart moving onto home
            // happy sound, score goes up
            // remove heart, update heart tile
        }
        // heart is done sliding
        return NO;
    }
}

- (NSString*) description
{
    return @"Heart";
}

@end

@implementation ArcticSlideHouse

- (BOOL)push:(pos_t)fromPosition :(dir_e)inDirection
{
    // Can't push the house. Queue a fail beep.
    // The penguin can't move there.
    return NO;
}

- (NSString*) description
{
    return @"House";
}
@end

@implementation ArcticSlideIceBlock

- (BOOL)push:(pos_t)fromPosition :(dir_e)inDirection
{
    ArcticSlideTile *tile = [model getTile:fromPosition:inDirection];
    if ( [model getEmpty] == tile )
    {
        // an ice block can be slid onto an empty space
        // animate bomb moving into space
        // remove from old pos
        // insert at new pos
        // call our own slide method or call the model's
        // slide method; ice block will not be crushed
        // when it gets a slide call
    }
    else
    {
        // pushing an ice block against anything else --
        // edge of the world, or any other tile item --
        // results in crushing the block
        // queue a crumble animation
        // then delete the ice block
    }
    // The penguin cannot actually move onto the position this round
    return NO;
}

- (BOOL)slide:(pos_t)fromPosition :(dir_e)inDirection
{
    ArcticSlideTile *tile = [model getTile:fromPosition:inDirection];
    if ( [model getEmpty] == tile )
    {
        // we can move onto this tile -- update the model with
        // the new position
        // return YES to indicate that we are still sliding
        // and slide should be called again
        return YES;
    }
    else
    {
        // pushing an ice block against anything else --
        // edge of the world, or any other tile item --
        // results in crushing the block
        // queue a crumble animation
        // then delete the ice block
        // block is done sliding
        return NO;
    }
}

- (NSString*) description
{
    return @"Ice Block";
}

@end

@implementation ArcticSlideMountain

- (BOOL)push:(pos_t)fromPosition :(dir_e)inDirection
{
    // Can't push the house. Queue a fail beep.
    // The penguin can't move there.
    return NO;
}

- (NSString*) description
{
    return @"Mountain";
}

@end

@implementation ArcticSlideTree

- (BOOL)push:(pos_t)fromPosition :(dir_e)inDirection
{
    // The penguin can actually walk through trees
    // come up with a way to represent penguin-over-tree
    // with alpha or masking?
    return YES;
}

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

- (ArcticSlideBomb*)getBomb
{
    if ( nil == bomb )
    {
        bomb = [[ArcticSlideBomb alloc] init];
    }
    return bomb;
}

- (ArcticSlideEmpty*)getEmpty
{
    if ( nil == empty )
    {
        empty = [[ArcticSlideEmpty alloc] init];
    }
    return empty;
}

- (ArcticSlideHeart*)getHeart
{
    if ( nil == heart )
    {
        heart = [[ArcticSlideHeart alloc] init];
    }
    return heart;
}

- (ArcticSlideHouse*)getHouse
{
    if ( nil == house )
    {
        house = [[ArcticSlideHouse alloc] init];
    }
    return house;
}

- (ArcticSlideIceBlock*)getIceBlock
{
    if ( nil == ice_block )
    {
        ice_block = [[ArcticSlideIceBlock alloc] init];
    }
    return ice_block;
}

- (ArcticSlideMountain*)getMountain
{
    if ( nil == mountain )
    {
        mountain = [[ArcticSlideMountain alloc] init];
    }
    return mountain;
}

- (ArcticSlideTree*)getTree
{
    if ( nil == tree )
    {
        tree = [[ArcticSlideTree alloc] init];
    }
    return tree;
}

- (id)initWithLevelIndex:(int)level_idx
{
    // Call our own basic initializer. This will result in redundant
    // setting of board values, but maybe I will clean that up
    // later.
    self = [self init];

    // A simple lookup table to decode the original Polar resource
    // data as strings
    // Oy, after all these years, I still can't use a const int type for the array size!
    ArcticSlideTile *polar_data_tile_map[POLAR_DATA_NUM_TILE_VALS] = {
        empty, tree, mountain, house, ice_block, heart, bomb };

    if ( level_idx > ( num_polar_levels - 1) )
    {
        NSLog(@"initWithLevelLayout: received level_idx out of range!\n");
        self = nil;
    }
    else
    {
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

- (ArcticSlideTile*)getTile:(pos_t)fromPosition :(dir_e)toDirection
{
    return nil;
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
