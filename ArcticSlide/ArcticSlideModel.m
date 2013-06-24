//
//  ArcticSlideModel.m
//  ArcticSlide
//
//  Created by Paul R. Potts on 6/4/13.
//  Copyright (c) 2013 Paul R. Potts. All rights reserved.
//

#import "ArcticSlideModel.h"
#import "PolarBoards.h"

// static ArcticSlideModel* model_p;

NSString *dir_e_str_p = @"EAST";
NSString *dir_s_str_p = @"SOUTH";
NSString *dir_w_str_p = @"WEST";
NSString *dir_n_str_p = @"NORTH";
NSString *dir_invalid_str_p = @"INVALID";

pos_t getAdjacentPos( pos_t original_pos, dir_e dir )
{
    pos_t updated_pos = original_pos;
    int y_offset = 0;
    int x_offset = 0;
    switch ( dir )
    {
        case dir_east:
            x_offset = 1;
            break;
        case dir_south:
            y_offset = 1;
            break;
        case dir_west:
            x_offset = -1;
            break;
        case dir_north:
            y_offset = -1;
            break;
        default:
            NSLog( @"getAdjacentPos: invalid dir %d", dir );
    }
    updated_pos.y_idx += y_offset;
    updated_pos.x_idx += x_offset;;
    return updated_pos;
}

BOOL posValid( pos_t pos )
{
    return ( ( ( pos.y_idx >= 0 ) &&
               ( pos.y_idx < board_height  ) ) &&
             ( ( pos.x_idx >= 0 ) &&
               ( pos.x_idx < board_width ) ) );
}

NSString *dirToString( dir_e dir )
{
    switch ( dir ) {
    
        case dir_east: return dir_e_str_p;
            break;
        case dir_west: return dir_w_str_p;
            break;
        case dir_south: return dir_s_str_p;
            break;
        case dir_north: return dir_n_str_p;
            break;
        default: return dir_invalid_str_p;
            break;
    }
}

@implementation ArcticSlideModel

- (id)init
{
    self = [super init];

    // Penguin starts out in top left corner,
    // facing south so we see him face-on;
    // this should eventually be read
    // from a level. Heart count should too
    penguinPos.y_idx = 0;
    penguinPos.x_idx = 0;
    penguinDir = dir_south;
    heartCount = 3;

    for ( unsigned int idx_y = 0;
         idx_y < board_height; idx_y++ )
    {
        for ( unsigned int idx_x = 0;
             idx_x < board_width; idx_x++ )
        {
            board[idx_y][idx_x] = nil;
        }
    }
    
    return self;
}

- (id)initWithLevelIndex:(int)level_idx
{
    self = [self init];
    
    if ( level_idx > ( POLAR_DATA_NUM_LEVELS - 1) )
    {
        NSLog(@"initWithLevelIndex: bad level_idx %d!\n",
              level_idx);
        self = nil;
    }
    else
    {
        unsigned int level_data_idx = 0;
        for ( unsigned int idx_y = 0;
             idx_y < board_height; idx_y++ )
        {
            for ( unsigned int idx_x = 0;
                 idx_x < board_width; idx_x++ )
            {
                int polar_data_tile_val =
                    polar_levels[level_idx][level_data_idx];
                pos_t new_pos = { idx_y, idx_x };
                switch ( polar_data_tile_val )
                {
                    case POLAR_TILE_EMPTY:
                        board[idx_y][idx_x] = [[ArcticSlideEmpty alloc] initWithPos:new_pos];
                        break;
                    case POLAR_TILE_TREE:
                        board[idx_y][idx_x] = [[ArcticSlideTree alloc] initWithPos:new_pos];
                        break;
                    case POLAR_TILE_MOUNTAIN:
                        board[idx_y][idx_x] = [[ArcticSlideMountain alloc] initWithPos:new_pos];
                        break;
                    case POLAR_TILE_HOUSE:
                        board[idx_y][idx_x] = [[ArcticSlideHouse alloc] initWithPos:new_pos];
                        break;
                    case POLAR_TILE_ICE_BLOCK:
                        board[idx_y][idx_x] = [[ArcticSlideIceBlock alloc] initWithPos:new_pos];
                        break;
                    case POLAR_TILE_HEART:
                        board[idx_y][idx_x] = [[ArcticSlideHeart alloc] initWithPos:new_pos];
                        break;
                    case POLAR_TILE_BOMB:
                        board[idx_y][idx_x] = [[ArcticSlideBomb alloc] initWithPos:new_pos];
                        break;
                    default:
                        NSLog(@"Tile value %d is not a known Polar tile value!\n",
                              polar_data_tile_val );
                        board[idx_y][idx_x] = nil;
                        break;
                }
                level_data_idx++;
            }
        }
    }
    
    return self;
    
}

- (ArcticSlideTile*)getTileAdjacentToPos:(pos_t)pos
                                     due:(dir_e)dir
{
    pos_t updated_pos = getAdjacentPos(pos, dir);
    if ( posValid( updated_pos ) )
    {
        return board[updated_pos.y_idx][updated_pos.x_idx];
    }
    else
    {
        return nil;
    }
}

- (ArcticSlideTile*)getTileAdjacentToPenguinDue:(dir_e)dir
{
    return [self getTileAdjacentToPos:[self penguinPos]
                                       due:dir];
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
            [desc_str appendString:[board[idx_y][idx_x] description]];
        }
        [desc_str appendString:@"\n"];
    }
    return desc_str;
}

- (pos_t)penguinPos
{
    return self->penguinPos;
}

- (int)heartCount
{
    return self->heartCount;
}

- (void)setPenguinPos:(pos_t)pos
{
    self->penguinPos = pos;
}

- (void)decrementHeartCount
{
    if (heartCount > 0)
    {
        --heartCount;
    }
    else
    {
        NSLog( @"Heart count not >0 and received decrementHeartCount!" );
    }
}

- (BOOL)penguinPushDue:(dir_e)dir
{
    // Start what could be a cascade of events. Get the
    // tile the penguin is pushing against and determine
    // what to do from there.
    ArcticSlideTile *pushed_tile_p =
        [self getTileAdjacentToPenguinDue:dir];
    if ( pushed_tile_p )
    {
        NSLog( @"penguinPush: tile at %d, %d pushed",
              [pushed_tile_p pos].y_idx,
              [pushed_tile_p pos].x_idx );
        return [pushed_tile_p pushMeDue:dir
                              withModel:self ];
    }
    else
    {
        NSLog(@"penguinPush: useless push against board edge");
        return NO;
    }
}

- (void)penguinMoveDue:(dir_e)dir
{
    if ( penguinDir != dir )
    {
        penguinDir = dir;
        NSLog( @"Penguin direction changed to %@",
               dirToString( dir ) );
    }
    else
    {
        NSLog( @"Penguin moving %@",
               dirToString( dir ) );
        if ( [self penguinPushDue:penguinDir ] )
        {
            pos_t new_penguin_pos = getAdjacentPos( [self penguinPos], dir );
            [self setPenguinPos:new_penguin_pos];
            NSLog( @"Penguin position updated to: %d, %d",
                   new_penguin_pos.y_idx, new_penguin_pos.x_idx );
        }
        if ( 0 == [self heartCount] )
        {
            NSLog( @"Heart count reached zero, level cleared!" );
            // Umm, do something at a higher level
        }
    }
}

- (void)penguinMoveNTimes:(int)n
                      due:(dir_e)dir
{
    NSLog( @"penguinMove:%@ nTimes:%d",
           dirToString( dir ), n );
    for (int move_count = 0; move_count < n; move_count++ )
    {
        [ self penguinMoveDue:dir ];
    }
}

- (ArcticSlideTile*)setBombAt:(pos_t)pos
{
    ArcticSlideTile *bomb_p =
        [[ArcticSlideBomb alloc] initWithPos:pos];
    board[pos.y_idx][pos.x_idx] = bomb_p;
    return bomb_p;
}

- (ArcticSlideTile*)setHeartAt:(pos_t)pos
{
    ArcticSlideTile *heart_p =
        [[ArcticSlideHeart alloc] initWithPos:pos];
    board[pos.y_idx][pos.x_idx] = heart_p;
    return heart_p;
}

- (ArcticSlideTile*)setIceBlockAt:(pos_t)pos
{
    ArcticSlideTile *ice_block_p =
        [[ArcticSlideIceBlock alloc] initWithPos:pos];
    board[pos.y_idx][pos.x_idx] = ice_block_p;
    return ice_block_p;
}

- (ArcticSlideTile*)setEmptyAt:(pos_t)pos
{
    ArcticSlideTile *empty_p =
        [[ArcticSlideEmpty alloc] initWithPos:pos];
    board[pos.y_idx][pos.x_idx] = empty_p;
    return empty_p;
}

// Call to initiate a slide, updating the board as we go;
// returns the tile that stops the slide; updates bomb
- (ArcticSlideTile*)slideBomb:(ArcticSlideBomb**)bomb_p_p
                          due:(dir_e)dir
                    withModel:(ArcticSlideModel*)model_p
{
    ArcticSlideTile *prev_tile_p = (ArcticSlideTile*)*bomb_p_p;
    ArcticSlideTile *next_tile_p =
        [model_p getTileAdjacentToPos:[*bomb_p_p pos]
                                       due:dir];

    if ( [next_tile_p is_sliding_accessible ] )
    {
        do
        {
            [model_p queueTransition:@"bomb slid"];
            
            // next tile becomes bomb
            next_tile_p = [model_p setBombAt:[next_tile_p pos]];
            
            // bomb tile becomes empty; set to new bomb tile
            prev_tile_p = [model_p setEmptyAt:[prev_tile_p pos]];
            
            // move along
            prev_tile_p = next_tile_p;
            next_tile_p =
            [model_p getTileAdjacentToPos:[next_tile_p pos]
                                           due:dir];
        }
        while ( [next_tile_p is_sliding_accessible ] );

        *bomb_p_p = (ArcticSlideBomb*)prev_tile_p;
    }
    return next_tile_p;
}

// Call to initiate a slide, updating the board as we go;
// returns the tile that stops the slide; updates heart
- (ArcticSlideTile*)slideHeart:(ArcticSlideHeart**)heart_p_p
                           due:(dir_e)dir
                    withModel:(ArcticSlideModel*)model_p
{
    ArcticSlideTile *prev_tile_p = (ArcticSlideTile*)*heart_p_p;
    ArcticSlideTile *next_tile_p =
    [model_p getTileAdjacentToPos:[*heart_p_p pos]
                                   due:dir];
    
    if ( [next_tile_p is_sliding_accessible ] )
    {
        do
        {
            [model_p queueTransition:@"heart slid"];
            
            // next tile becomes heart
            next_tile_p = [model_p setHeartAt:[next_tile_p pos]];
            
            // heart tile becomes empty; set to new heart tile
            prev_tile_p = [model_p setEmptyAt:[prev_tile_p pos]];
            
            // move along
            prev_tile_p = next_tile_p;
            next_tile_p =
            [model_p getTileAdjacentToPos:[next_tile_p pos]
                                           due:dir];
        }
        while ( [next_tile_p is_sliding_accessible ] );
        
        *heart_p_p = (ArcticSlideHeart*)prev_tile_p;
    }
    return next_tile_p;
}

// Call to initiate a slide, updating the board as we go;
// returns the tile that stops the slide; updates heart
- (ArcticSlideTile*)slideIceBlock:(ArcticSlideIceBlock**)ice_block_p_p
                              due:(dir_e)dir
                        withModel:(ArcticSlideModel *)model_p
{
    ArcticSlideTile *prev_tile_p = (ArcticSlideTile*)*ice_block_p_p;
    ArcticSlideTile *next_tile_p =
    [model_p getTileAdjacentToPos:[*ice_block_p_p pos]
                                   due:dir];
    
    if ( [next_tile_p is_sliding_accessible ] )
    {
        do
        {
            [model_p queueTransition:@"ice block slid"];
            
            // next tile becomes ice block
            next_tile_p = [model_p setIceBlockAt:[next_tile_p pos]];
            
            // ice block tile becomes empty; set to new ice block tile
            prev_tile_p = [model_p setEmptyAt:[prev_tile_p pos]];
            
            // move along
            prev_tile_p = next_tile_p;
            next_tile_p =
            [model_p getTileAdjacentToPos:[next_tile_p pos]
                                           due:dir];
        }
        while ( [next_tile_p is_sliding_accessible ] );
        
        *ice_block_p_p = (ArcticSlideIceBlock*)prev_tile_p;
    }
    return next_tile_p;
}

- (void)queueTransition:(NSString*)str_p
{
    NSLog( @"%@", str_p );
}

@end

@implementation ArcticSlideTile

- (id)init
{
    is_sliding_accessible = NO;
    is_penguin_accessible = YES;
    is_blowupable = NO;
    is_crushable = NO;
    is_goal = NO;
    return self;
}

- (id)initWithPos:(pos_t)initial_pos
{
    pos = initial_pos;
    return [self init];
}

- (pos_t)pos
{
    return self->pos;
}

- (BOOL) is_sliding_accessible
{
    return is_sliding_accessible;
}

- (BOOL) is_penguin_accessible
{
    return is_penguin_accessible;
}

- (BOOL) is_blowupable
{
    return is_blowupable;
}

- (BOOL) is_crushable
{
    return is_crushable;
}

- (BOOL) is_goal
{
    return is_goal;
}

- (BOOL)pushMeDue:(dir_e)dir
        withModel:(ArcticSlideModel*)model_p
{
    // Base class method handles mountain and house;
    // Peguin can't walk on them or get them sliding
    // by pushing them
    [model_p queueTransition:@"can't move immovable object"];
    
    // The penguin cannot actually move in this turn
    return NO;
}

@end

@implementation ArcticSlideBomb

- (id)init
{
    // Sliding things can slide on this tile
    is_sliding_accessible = NO;
    // The penguin can walk on this tile
    is_penguin_accessible = NO;
    
    is_blowupable = YES;
    is_crushable = NO;
    is_goal = NO;
    return self;
}

- (BOOL)pushMeDue:(dir_e)dir
        withModel:(ArcticSlideModel*)model_p
{
    // The penguin has pushed us (a bomb)
    ArcticSlideBomb *bomb_p = self;
    ArcticSlideTile *next_tile_p =
        [model_p getTileAdjacentToPos:pos
                                       due:dir];
    if ( nil == next_tile_p )
    {
        // Bomb is being pushed into edge of board;
        // maye we queue up a push failure sound effect
        [model_p queueTransition:@"bomb pushed into edge of world"];
    }
    else
    {
        // Attempt to slide the bomb; returns tile
        // that stops the slide (after zero or more
        // tiles are traversed)
        next_tile_p = [model_p slideBomb:&bomb_p
                                     due:dir
                               withModel:model_p];

        // Special case: bomb can blow up mountain after sliding zero
        // or more spaces
        if ( [ next_tile_p is_blowupable ] )
        {
            [model_p queueTransition:@"bomb blew up mountain"];
            
            // next tile (mountain) becomes empty
            next_tile_p = [model_p setEmptyAt:[next_tile_p pos]];
            
            // bomb tile becomes empty
            (void)[model_p setEmptyAt:[bomb_p pos]];
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

- (id)init
{
    // Sliding things can slide on this tile
    is_sliding_accessible = YES;
    // The penguin can walk on this tile
    is_penguin_accessible = YES;

    is_blowupable = NO;
    is_crushable = NO;
    is_goal = NO;
    return self;
}

- (BOOL)pushMeDue:(dir_e)dir
        withModel:(ArcticSlideModel*)model_p
{
    // The penguin can traverse an empty tile
    // TODO: use the model_p to send an update of the penguin
    // position
    [model_p queueTransition:@"move penguin"];

    return YES;
}

- (NSString*) description
{
    return @"      ";
}
@end

@implementation ArcticSlideHeart

- (id)init
{
    // Sliding things can slide on this tile
    is_sliding_accessible = NO;
    // The penguin can walk on this tile
    is_penguin_accessible = NO;
    
    is_blowupable = NO;
    is_crushable = NO;
    is_goal = NO;
    return self;
}

- (BOOL)pushMeDue:(dir_e)dir
        withModel:(ArcticSlideModel*)model_p
{
    // The penguin has pushed us (a heart)
    ArcticSlideHeart *heart_p = self;
    ArcticSlideTile *next_tile_p =
        [model_p getTileAdjacentToPos:pos
                               due:dir];
    if ( nil == next_tile_p )
    {
        // Heart is being pushed into edge of board;
        // maye we queue up a push failure sound effect
        [model_p queueTransition:@"heart pushed into edge of world"];
    }
    else
    {
        // Attempt to slide the heart; returns tile
        // that stops the slide (after zero or more
        // tiles are traversed)
        next_tile_p = [model_p slideHeart:&heart_p
                                      due:dir
                                withModel:model_p];
        // Special case: heart can enter house after sliding zero
        // or more spaces
        if ( [ next_tile_p is_goal ] )
        {
            [model_p queueTransition:@"heart entered home"];
            [model_p decrementHeartCount];
            // House is not changed; heart tile becomes empty
            (void)[model_p setEmptyAt:[heart_p pos]];
        }
    }

    // The penguin cannot actually move in this turn
    return NO;
}

- (NSString*) description
{
    return @"Heart ";
}

@end

@implementation ArcticSlideHouse

- (id)init
{
    // Sliding things can slide on this tile
    is_sliding_accessible = NO;
    // The penguin can walk on this tile
    is_penguin_accessible = NO;
    
    is_blowupable = NO;
    is_crushable = NO;
    is_goal = YES;
    return self;
}

- (NSString*) description
{
    return @"House ";
}
@end

@implementation ArcticSlideIceBlock

- (id)init
{
    // Sliding things can slide on this tile
    is_sliding_accessible = NO;
    // The penguin can walk on this tile
    is_penguin_accessible = NO;
    
    is_blowupable = NO;
    is_crushable = YES;
    is_goal = NO;
    return self;
}

- (BOOL)pushMeDue:(dir_e)dir
        withModel:(ArcticSlideModel*)model_p
{
    // The penguin has pushed us (an ice block) in
    // the given direction. If we are adjacent
    // to an empty tile we can slide at least
    // one tile:
    ArcticSlideIceBlock *ice_block_p = self;
    ArcticSlideTile *next_tile_p =
    [model_p getTileAdjacentToPos:pos
                           due:dir];
    if ( next_tile_p && [next_tile_p is_sliding_accessible] )
    {
        // Attempt to slide the ice block; returns tile
        // that stops the slide (after zero or more
        // tiles are traversed)
        next_tile_p = [model_p slideIceBlock:&ice_block_p
                                         due:dir
                                    withModel:model_p];
        // When it comes to a stop, it just stops; no
        // special behavior takes place
    }
    else
    {
        // Ice block is being pushed into edge of board
        // or a non-slideable tile; this crushes & destroys
        // the ice block
        [model_p queueTransition:@"ice block crushed"];
        (void)[model_p setEmptyAt:[ice_block_p pos]];
    }
    
    // The penguin cannot actually move in this turn
    return NO;
}

- (NSString*) description
{
    return @"Ice   ";
}

@end

@implementation ArcticSlideMountain

- (id)init
{
    // Sliding things can slide on this tile
    is_sliding_accessible = NO;
    // The penguin can walk on this tile
    is_penguin_accessible = NO;
    
    is_blowupable = YES;
    is_crushable = NO;
    is_goal = NO;
    return self;
}

- (NSString*) description
{
    return @"Mtn   ";
}

@end

@implementation ArcticSlideTree

- (id)init
{
    // Sliding things can slide on this tile
    is_sliding_accessible = NO;
    // The penguin can walk on this tile
    is_penguin_accessible = YES;
    
    is_blowupable = NO;
    is_crushable = NO;
    is_goal = NO;
    return self;
}

- (BOOL)pushMeDue:(dir_e)dir
        withModel:(ArcticSlideModel*)model_p;
{
    // The penguin can actually walk through trees
    // come up with a way to represent penguin-over-tree
    // with alpha or masking?
    [model_p queueTransition:@"penguin can walk on tile with trees"];
    return YES;
}

- (NSString*) description
{
    return @"Tree  ";
}
@end

