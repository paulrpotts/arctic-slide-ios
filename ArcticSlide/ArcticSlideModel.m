//
//  ArcticSlideModel.m
//  ArcticSlide
//
//  Created by Paul R. Potts on 6/4/13.
//  Copyright (c) 2013 Paul R. Potts. All rights reserved.
//

#import "ArcticSlideModel.h"
#import "PolarBoards.h"

static ArcticSlideBomb* bomb_p;
static ArcticSlideEmpty* empty_p;
static ArcticSlideHeart* heart_p;
static ArcticSlideHouse* house_p;
static ArcticSlideIceBlock* ice_block_p;
static ArcticSlideMountain* mountain_p;
static ArcticSlideTree* tree_p;
static ArcticSlideModel* model_p;

pos_t getUpdatedPos( pos_t original_pos, dir_e dir )
{
    pos_t updated_pos = original_pos;
    int x_offset = 0;
    int y_offset = 0;
    if ( dir_east == dir )
    {
        x_offset = 1;
        y_offset = 0;
    }
    else if ( dir_west == dir )
    {
        x_offset = -1;
        y_offset = 0;
    }
    else if ( dir_north == dir )
    {
        x_offset = 0;
        y_offset = -1;
    }
    else if ( dir_south == dir )
    {
        x_offset = 0;
        y_offset = +1;
    }
    updated_pos.x_idx += x_offset;;
    updated_pos.y_idx += y_offset;
    return updated_pos;
}

BOOL posValid( pos_t pos )
{
    return ( ( ( pos.x_idx >= 0 ) || ( pos.x_idx < board_width  ) ) ||
             ( ( pos.y_idx >= 0 ) || ( pos.y_idx < board_height ) ) );
}

@implementation ArcticSlideTile
// These versions in the base class should not be called; all instantiated
// tile objects should have either overriden them or should have not been
// send these messages.
- (BOOL)pushFromPosition:(pos_t)pos inDirection:(dir_e)dir
{
    NSLog(@"ArcticSlideTile push method called!\n");
    // Don't let the penguin move onto this space
    return NO;
}

// Override alloc and init to prevent casual instantiation
- (id)alloc
{
    NSLog(@"ArcticSlideTile alloc method called!\n");
    return nil;
}

- (id)init
{
    NSLog(@"ArcticSlideTile init method called!\n");
    return nil;
}

- (id)initWithModel:( ArcticSlideModel*)model_p
{
    return self;
}

@end

@implementation ArcticSlideBomb

- (BOOL)pushFromPosition:(pos_t)pos inDirection:(dir_e)dir
{
    // Penguin has pushed bomb in the given direction.
    // Get our own position:
    pos_t bomb_pos = getUpdatedPos( pos, dir );
    // What are we being pushed into?
    ArcticSlideTile *target_tile_p =
    [model_p getTileFromPosition:bomb_pos
                     inDirection:dir];
    
    if ( nil == target_tile_p )
    {
        // Edge of the world. TODO:
        // queue a "boop" sound effect
    }
    else if ( [model_p getMountain] == target_tile_p )
    {
        // bomb pushed into mountain
        // TODO: queue animation of bomb moving onto
        // mountain, animate explosion
        // remove bomb and mountain
        pos_t new_bomb_pos = getUpdatedPos( bomb_pos, dir );
        [model_p setTileAtPosition:new_bomb_pos
                                to:[model_p getEmpty]];
        new_bomb_pos = getUpdatedPos( new_bomb_pos, dir );
        [model_p setTileAtPosition:new_bomb_pos
                                to:[model_p getEmpty]];
    }
    else if ( [model_p getEmpty]
             == target_tile_p )
    {
        // TODO: queue bomb moving into space
        pos_t new_bomb_pos = getUpdatedPos( bomb_pos, dir );
        // Set bomb at new position
        [model_p setTileAtPosition:new_bomb_pos
                                to:[model_p getBomb]];
        // Remove bomb from old position
        [model_p setTileAtPosition:bomb_pos
                                to:[model_p getEmpty]];

        // Bombs will continue to slide until stopped
        ArcticSlideTile *target_tile_p =
        [model_p getTileFromPosition:new_bomb_pos
                         inDirection:dir];

        while ( [model_p getEmpty] == target_tile_p )
        {
            // TODO: animate bomb moving into space
            pos_t new_bomb_pos = getUpdatedPos( bomb_pos, dir );
            // set bomb at new position
            [model_p setTileAtPosition:new_bomb_pos
                                    to:[model_p getBomb]];
            // remove bomb from oald position
            [model_p setTileAtPosition:bomb_pos
                                    to:[model_p getEmpty]];
        }

        if ( [model_p getMountain]
            == target_tile_p )
        {
            // bomb pushed into mountain
            // TODO: queue animation of bomb moving
            // onto mountain, animate explosion
            // remove bomb and mountain
            [model_p setTileAtPosition:new_bomb_pos
                                    to:[model_p getEmpty]];
            new_bomb_pos = getUpdatedPos( new_bomb_pos, dir );
            [model_p setTileAtPosition:new_bomb_pos
                                    to:[model_p getEmpty]];
        }
    }
    // The penguin cannot actually move in this turn
    return NO;
}

- (NSString*) description
{
    return @"Bomb  ";
}

@end

@implementation ArcticSlideEmpty
- (BOOL)pushFromPosition:(pos_t)pos inDirection:(dir_e)dir
{
    // If the penguin pushes onto an empty tile, he can always
    // move there
    return YES;
}

- (NSString*) description
{
    return @"      ";
}
@end

@implementation ArcticSlideHeart

- (BOOL)pushFromPosition:(pos_t)pos inDirection:(dir_e)dir
{
    ArcticSlideTile *tile_p = [model_p getTileFromPosition:pos inDirection:dir];
    if ( nil == tile_p )
    {
        // there is nothing there -- we're pushing against
        // the edge of the world. queue a fail beep
    }
    else if ( [model_p getHouse] == tile_p )
    {
        // heart pushed into home
        // animate heart moving onto home
        // happy sound, score goes up
        // remove heart, update heart tile
    }
    else if ( [model_p getEmpty] == tile_p )
    {
        // animate bomb moving into space
        // remove from old pos
        // insert at new pos
    }
    // The penguin cannot actually move onto the position this round
    return NO;
}

- (NSString*) description
{
    return @"Heart ";
}

@end

@implementation ArcticSlideHouse

- (BOOL)pushFromPosition:(pos_t)pos inDirection:(dir_e)dir
{
    // Can't push the house. Queue a fail beep.
    // The penguin can't move there.
    return NO;
}

- (NSString*) description
{
    return @"House ";
}
@end

@implementation ArcticSlideIceBlock

- (BOOL)pushFromPosition:(pos_t)pos inDirection:(dir_e)dir
{
    ArcticSlideTile *tile_p = [model_p getTileFromPosition:pos inDirection:dir];
    if ( [model_p getEmpty] == tile_p )
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

- (NSString*) description
{
    return @"Ice   ";
}

@end

@implementation ArcticSlideMountain

- (BOOL)pushFromPosition:(pos_t)pos inDirection:(dir_e)dir
{
    // Can't push the house. Queue a fail beep.
    // The penguin can't move there.
    return NO;
}

- (NSString*) description
{
    return @"Mtn   ";
}

@end

@implementation ArcticSlideTree

- (BOOL)pushFromPosition:(pos_t)pos inDirection:(dir_e)dir
{
    // The penguin can actually walk through trees
    // come up with a way to represent penguin-over-tree
    // with alpha or masking?
    return YES;
}

- (NSString*) description
{
    return @"Tree  ";
}
@end

@implementation ArcticSlideModel

- (id)init
{
    for ( unsigned int idx_y = 0;
         idx_y < board_height; idx_y++ )
    {
        for ( unsigned int idx_x = 0;
             idx_x < board_width; idx_x++ )
        {
            board[idx_y][idx_x] = [self getEmpty];
        }
    }
    return self;
}

- (ArcticSlideBomb*)getBomb
{
    if ( nil == bomb_p )
    {
        bomb_p = [[ArcticSlideBomb alloc] initWithModel:self];
    }
    return bomb_p;
}

- (ArcticSlideEmpty*)getEmpty
{
    if ( nil == empty_p )
    {
        empty_p = [[ArcticSlideEmpty alloc] initWithModel:self];
    }
    return empty_p;
}

- (ArcticSlideHeart*)getHeart
{
    if ( nil == heart_p )
    {
        heart_p = [[ArcticSlideHeart alloc] initWithModel:self];
    }
    return heart_p;
}

- (ArcticSlideHouse*)getHouse
{
    if ( nil == house_p )
    {
        house_p = [[ArcticSlideHouse alloc] initWithModel:self];
    }
    return house_p;
}

- (ArcticSlideIceBlock*)getIceBlock
{
    if ( nil == ice_block_p )
    {
        ice_block_p = [[ArcticSlideIceBlock alloc] initWithModel:self];
    }
    return ice_block_p;
}

- (ArcticSlideMountain*)getMountain
{
    if ( nil == mountain_p )
    {
        mountain_p = [[ArcticSlideMountain alloc] initWithModel:self];
    }
    return mountain_p;
}

- (ArcticSlideTree*)getTree
{
    if ( nil == tree_p )
    {
        tree_p = [[ArcticSlideTree alloc] initWithModel:self];
    }
    return tree_p;
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
        [self getEmpty], [self getTree], [self getMountain], [self getHouse],
        [self getIceBlock], [self getHeart], [self getBomb]
    };

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

- (ArcticSlideTile*)getTileFromPosition:(pos_t)pos inDirection:(dir_e)dir
{
    pos_t updated_pos = getUpdatedPos(pos, dir);
    if ( posValid( updated_pos ) )
    {
        return board[updated_pos.y_idx][updated_pos.x_idx];
    }
    else
    {
        return nil;
    }
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

- (void)setTileAtPosition:(pos_t)pos to:(ArcticSlideTile*)type
{
    board[pos.y_idx][pos.x_idx] = type;
}

@end
