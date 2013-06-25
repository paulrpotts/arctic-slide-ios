//
//  ArcticSlideModel.m
//  ArcticSlide
//
//  Created by Paul R. Potts on 6/4/13.
//
// Width guides for code to be formatted for Blogger: 67 chars for 860 px,
// (my previous template), 80 chars for 960 px (my current template).
//
//34567890123456789012345678901234567890123456789012345678901234567
//345678901234567890123456789012345678901234567890123456789012345678901234567890

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
               ( pos.y_idx < POLAR_DATA_LEN_Y  ) ) &&
             ( ( pos.x_idx >= 0 ) &&
               ( pos.x_idx < POLAR_DATA_LEN_X ) ) );
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
          idx_y < POLAR_DATA_LEN_Y; idx_y++ )
    {
        for ( unsigned int idx_x = 0;
              idx_x < POLAR_DATA_LEN_X; idx_x++ )
        {
            board[idx_y][idx_x] = polar_tile_empty;
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
        for ( unsigned int idx_y = 0;
              idx_y < POLAR_DATA_LEN_Y; idx_y++ )
        {
            for ( unsigned int idx_x = 0;
                  idx_x < POLAR_DATA_LEN_X; idx_x++ )
            {
                board[idx_y][idx_x] =
                    polar_levels[level_idx][idx_y][idx_x];
            }
        }
    }
    
    return self;
    
}

- (pos_t)penguinPos
{
    return self->penguinPos;
}

- (int)heartCount
{
    return self->heartCount;
}

- (tile_t)getTileAtPos:(pos_t)pos
{
    if ( posValid( pos ) )
    {
        return self->board[pos.y_idx][pos.x_idx];
    }
    else
    {
        return polar_tile_edge;
    }
}

- (tile_t)getTileAdjacentToPenguinDue:(dir_e)dir
{
    return [self getTileAdjacentToPos:[self penguinPos]
                                  due:dir];
}

- (tile_t)getTileAdjacentToPos:(pos_t)pos
                           due:(dir_e)dir
{
    pos_t adjacent_pos = getAdjacentPos(pos, dir);
    if ( posValid( adjacent_pos ) )
    {
        return board[adjacent_pos.y_idx][adjacent_pos.x_idx];
    }
    else
    {
        return polar_tile_edge;
    }
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

- (void)setTile:(tile_t)tile
          AtPos:(pos_t)pos
{
    if ( NO == posValid( pos ) )
    {
        NSLog( @"setTile: called at pos %d, %d (invalid)\n",
               pos.y_idx, pos.x_idx );
    }
    else if ( polar_tile_edge == tile )
    {
        NSLog( @"setTile: called at pos %d, %d with edge\n",
               pos.y_idx, pos.x_idx );
    }
    else
    {
        self->board[pos.y_idx][pos.x_idx] = tile;
    }
   
}

- (NSString*)description
{
    static NSString *empty_str_p = @"____";
    static NSString *tree_str_p = @"tre ";
    static NSString *mountain_str_p = @"mtn ";
    static NSString *house_str_p = @"hou ";
    static NSString *ice_block_str_p = @"ice ";
    static NSString *heart_str_p = @"hea ";
    static NSString *bomb_str_p = @"bom ";
    static NSString *unknown_str_p = @"??? ";
    
    NSMutableString *desc_str =[[NSMutableString alloc]init];
    [desc_str appendString:@"ArcticSlideModel board state:\n"];
    for ( unsigned int idx_y = 0;
         idx_y < POLAR_DATA_LEN_Y; idx_y++ )
    {
        for ( unsigned int idx_x = 0;
             idx_x < POLAR_DATA_LEN_X; idx_x++ )
        {
            NSString *tile_str_p = unknown_str_p;
            switch ( self->board[idx_y][idx_x] )
            {
                case polar_tile_empty:
                    tile_str_p = empty_str_p;
                    break;
                case polar_tile_tree:
                    tile_str_p = tree_str_p;
                    break;
                case polar_tile_mountain:
                    tile_str_p = mountain_str_p;
                    break;
                case polar_tile_house:
                    tile_str_p = house_str_p;
                    break;
                case polar_tile_ice_block:
                    tile_str_p = ice_block_str_p;
                    break;
                case polar_tile_heart:
                    tile_str_p = heart_str_p;
                    break;
                case polar_tile_bomb:
                    tile_str_p = bomb_str_p;
                    break;
                default:
                    break;
            }
            [ desc_str appendString:tile_str_p ];
        }
        [ desc_str appendString:@"\n" ];
    }
    return desc_str;
}

- (void)queueTransition:(NSString*)str_p
{
    NSLog( @"%@", str_p );
}

// slideTile handles movable tiles moving, updating the board
// as they go. For any movable tile and empty tile, we move
// the piece and call slide again. For the generic movable
// tile and any other tile case, we call collide, because
// the interaction of bomb/mountain and heart/house are the
// same whether it is the result of a direct push or takes
// place after a slide. slide for an ice block is a special
// case: the ice block is not destroyed after a slide, it
// just stops. In the Dylan implementation we rely on runtime
// dispatch to handle dispatch depending on two different
// class type values in order from most to least specific;
// in Objective-C we use explicit branching logic.
- (void)slideTile:(tile_t)first_tile
            atPos:(pos_t)first_pos
              due:(dir_e)dir
           toTile:(tile_t)second_tile
      atSecondPos:(pos_t)second_pos
{
    BOOL empty = ( second_tile == polar_tile_empty );
    /* Blocking includes the special edge tile value */
    BOOL blocking = ( second_tile != polar_tile_empty );
    
    BOOL ice_block = ( first_tile == polar_tile_ice_block );
    BOOL movable = ( ice_block ||
                     first_tile == polar_tile_bomb ||
                     first_tile == polar_tile_heart );

    if ( ice_block && blocking )
    {
        // A specific movable tile, ice-block, meets a
        // blocking tile; don't call collide since the behavior
        // of a sliding ice block is different than a pushed ice
        // block. It just stops and doesn't break.
        NSLog( @"slideTile: ice block / blocking\n" );       
    }
    else if ( movable && empty )
    {
        // A movable tile interacting with an empty tile --
        // move forward on the board and call slide again.
        NSLog( @"slideTile: movable / empty\n" );

        // Recursive Implementation:
#if 0
        pos_t third_pos = getAdjacentPos( second_pos, dir );
        tile_t third_tile = [ self getTileAtPos:third_pos ];
        [ self setTile:polar_tile_empty AtPos:first_pos ];
        [ self setTile:first_tile AtPos:second_pos ];
        [ self slideTile:first_tile atPos:second_pos due:dir
                  toTile:third_tile atSecondPos:third_pos ];
#endif
        // Iterative: if we need to avoid possibly calling
        // ourselves up to 23 times
#if 1
        while ( NO == blocking )
        {
            pos_t third_pos = getAdjacentPos( second_pos, dir );
            tile_t third_tile = [ self getTileAtPos:third_pos ];
            [ self setTile:polar_tile_empty AtPos:first_pos ];
            [ self setTile:first_tile AtPos:second_pos ];
            first_pos = second_pos;
            second_pos = third_pos;
            second_tile = third_tile;
            blocking = ( third_tile != polar_tile_empty );
        }
        if ( ice_block )
        {
            NSLog( @"slideTile: ice block / blocking\n" );
        }
        else
        {
            NSLog( @"slideTile: movable / blocking\n" );
            [ self collideTile:first_tile atPos:first_pos due:dir
                      withTile:second_tile atSecondPos:second_pos ];
        }        
#endif
    }
    else if ( movable && blocking )
    {
        // A movable tile meets a blocking tile: call collide to
        // handle heart/house, bomb/mountain, edge of world, etc.
        NSLog( @"slideTile: movable / blocking\n" );
        [ self collideTile:first_tile atPos:first_pos due:dir
                  withTile:second_tile atSecondPos:second_pos ];
    }
}

// collideTile represents the pushed or sliding tile interacting
// with another tile. In the Dylan implementation we used a generic
// function and five methods with some overlap in types, assuming
// the runtime could figure out the most specific matching method
// to call. In Objective-C we do our own explicit dispatch.
- (void)collideTile:(tile_t)first_tile
              atPos:(pos_t)first_pos
                due:(dir_e)dir
           withTile:(tile_t)second_tile
        atSecondPos:(pos_t)second_pos
{
    BOOL empty = ( second_tile == polar_tile_empty );
    /* Blocking includes the special edge tile value */
    BOOL blocking = ( second_tile != polar_tile_empty );
    BOOL mountain = ( second_tile == polar_tile_mountain );
    BOOL house = ( second_tile == polar_tile_house );

    BOOL ice_block = ( first_tile == polar_tile_ice_block );
    BOOL bomb = ( first_tile == polar_tile_bomb );
    BOOL heart = ( first_tile == polar_tile_heart );
    BOOL movable = ( ice_block || bomb || heart );

    if ( bomb && mountain )
    {
        /*
            When a bomb meets a mountain, both bomb and mountain blow up
        */
        NSLog( @"collideTile: bomb / mountain\n" );
        [ self setTile:polar_tile_empty AtPos:first_pos ];
        [ self setTile:polar_tile_empty AtPos:second_pos ];
    }
    else if ( heart && house )
    {
        /*
            When a bomb heart meets a house, we are closer to winning
        */
        NSLog( @"collideTile: heart / house\n" );
        [ self setTile:polar_tile_empty AtPos:first_pos ];
        [ self decrementHeartCount ];
    }
    else if ( ice_block && blocking )
    {
        /*
            When an ice block is pushed directly against any
            blocking tile (including the board edge), it is destroyed.
        */
        NSLog( @"collideTile: ice block / blocking\n" );
        [ self setTile:polar_tile_empty AtPos:first_pos ];
    }
    else if ( movable )
    {
        if ( empty )
        {
            /*
                A movable tile pushed onto an empty tile will slide
            */
            NSLog( @"collideTile: movable / empty: start slide\n" );
            [ self slideTile:first_tile atPos:first_pos due:dir
                   toTile:second_tile atSecondPos:second_pos ];
        }
        else if ( blocking )
        {
            /*
                When a generic movable piece meets any other
                blocking pieces not handled by a special case
                above, nothig happens; it stops. Maybe play
                a "fail" beep.
            */
            NSLog( @"collideTile: movable / blocking\n" );
        }
    }
}

// pushTile represents the penguin (player avatar) pushing a tile.
// In the Dylan implementation, we used a generic function and
// specialized on 3 distinct abstract subclasses of our tile class.
// Here we do our own explicit dispatch.
- (BOOL)pushTile:(tile_t)target_tile
             due:(dir_e)dir
              at:(pos_t)target_pos
{
    switch ( target_tile )
    {
        /*
            Handle the "walkable" cases. The penguin is allowed to move
            onto these tiles, indicated by returning YES
        */
        case polar_tile_empty: /* FALL THROUGH */
        case polar_tile_tree:
            NSLog( @"pushTile: walkable\n" );
            self->penguinPos = target_pos;
            return YES;

        /*
            Handle "movable" cases. Call collide which specializes in
            various combinations.
        */
        case polar_tile_bomb:      /* FALL THROUGH */
        case polar_tile_heart:     /* FALL THROUGH */
        case polar_tile_ice_block:
            NSLog( @"pushTile: movable\n" );
            {
                pos_t next_pos = getAdjacentPos( target_pos, dir );
                /*
                    Note that next-pos can be invalid, which results
                    in the special "edge" tile value.
                */
                tile_t next_tile = [ self getTileAtPos:next_pos ];
                [ self collideTile:target_tile atPos:target_pos
                    due:dir withTile:next_tile
                    atSecondPos:next_pos ];
            }
            return NO;

        /*
            Handle "fixed" cases. Do nothing; the GUI might play
            a "fail" beep.
        */
        case polar_tile_mountain:   /* FALL THROUGH */
        case polar_tile_house:
            NSLog( @"pushTile: fixed\n" );
            return NO;

        default:
            NSLog( @"pushTile: unexpected tile value %d\n",
                   target_tile );
            return NO;
    }
}

- (BOOL)penguinPushDue:(dir_e)dir
{
    pos_t pushed_tile_pos = getAdjacentPos( self->penguinPos, dir );
    tile_t pushed_tile = [ self getTileAtPos:pushed_tile_pos ];
    NSLog( @"penguinPush: tile at %d, %d pushed",
           pushed_tile_pos.y_idx,
           pushed_tile_pos.x_idx );
    return [ self pushTile:pushed_tile due:dir at:pushed_tile_pos ];
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
            NSLog( @"Penguin moved to: %d, %d",
                   self->penguinPos.y_idx, self->penguinPos.x_idx );
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
    for (int move_count = 0; move_count < n; move_count++ )
    {
        [ self penguinMoveDue:dir ];
    }
}

@end /* @implementation ArcticSlideModel */