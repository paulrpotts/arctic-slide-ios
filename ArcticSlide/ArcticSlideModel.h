//
//  ArcticSlideModel.h
//  ArcticSlide
//
//  Created by Paul R. Potts on 6/4/13.
//  Copyright (c) 2013 Paul R. Potts. All rights reserved.
//
// Width guides for code to be formatted for Blogger: 67 chars for 860 px,
// (my previous template), 80 chars for 960 px (my current template).
//
//34567890123456789012345678901234567890123456789012345678901234567
//345678901234567890123456789012345678901234567890123456789012345678901234567890

#import <Foundation/Foundation.h>
#include "PolarBoards.h"

typedef struct {
    int y_idx;
    int x_idx;
} pos_t;

typedef enum {
    dir_east,
    dir_west,
    dir_south,
    dir_north
} dir_e;

// Plain old C helper functions
pos_t getAdjacentPos( pos_t original_pos, dir_e dir );
BOOL posValid( pos_t pos );
NSString *dirToString( dir_e dir );

@interface ArcticSlideModel : NSObject
{
    polar_board_array_t board;
    pos_t penguinPos;
    dir_e penguinDir;
    int heartCount;
}

- (id)init;
- (id)initWithLevelIndex:(int)level_idx;
- (NSString*) description;

// Getters
- (pos_t)penguinPos;
- (int)heartCount;
- (tile_t)getTileAtPos:(pos_t)pos;
- (tile_t)getTileAdjacentToPenguinDue:(dir_e)dir;
- (tile_t)getTileAdjacentToPos:(pos_t)pos
                           due:(dir_e)dir;

// Setters/mutators
- (void)setPenguinPos:(pos_t)pos;
- (void)decrementHeartCount;
- (void)setTile:(tile_t)tile
          AtPos:(pos_t)pos;

- (BOOL)penguinPushDue:(dir_e)dir;

// Queue events to feed the GUI
- (void)queueTransition:(NSString*)str_p;

// Handle tile interactions: pushes, collisions, and slides
- (void)slideTile:(tile_t)first_tile
            atPos:(pos_t)first_pos
              due:(dir_e)dir
           toTile:(tile_t)second_tile
      atSecondPos:(pos_t)second_pos;

- (void)collideTile:(tile_t)first_tile
              atPos:(pos_t)first_pos
                due:(dir_e)dir
           withTile:(tile_t)second_tile
        atSecondPos:(pos_t)second_pos;

- (BOOL)pushTile:(tile_t)target_tile
             due:(dir_e)dir
              at:(pos_t)target_pos;

// The external API
- (void)penguinMoveDue:(dir_e)dir;
- (void)penguinMoveNTimes:(int)n
                      due:(dir_e)dir;

@end
