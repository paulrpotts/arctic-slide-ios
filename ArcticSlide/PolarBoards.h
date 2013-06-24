//
//  PolarBoards.h
//  ArcticSlide
//
//  Created by Paul R. Potts on 6/7/13.
//  Copyright (c) 2013 Paul R. Potts. All rights reserved.
//

// Width guides for code to be formatted for Blogger: 67 chars for 860 px,
// (my previous template), 80 chars for 960 px (my current template).
//
//34567890123456789012345678901234567890123456789012345678901234567
//345678901234567890123456789012345678901234567890123456789012345678901234567890

#define POLAR_DATA_NUM_TILE_VALS 7       // values 0-6 inclusive
#define POLAR_DATA_NUM_TILES 96          // 4x24 grid
#define POLAR_DATA_NUM_LEVELS 6          // In the original game

#define POLAR_TILE_EMPTY '0'
#define POLAR_TILE_TREE '1'
#define POLAR_TILE_MOUNTAIN '2'
#define POLAR_TILE_HOUSE '3'
#define POLAR_TILE_ICE_BLOCK '4'
#define POLAR_TILE_HEART '5'
#define POLAR_TILE_BOMB '6'
#define POLAR_DATA_MAX_TILE_VAL POLAR_TILE_BOMB

extern const char polar_levels[POLAR_DATA_NUM_LEVELS]
                              [POLAR_DATA_NUM_TILES];
