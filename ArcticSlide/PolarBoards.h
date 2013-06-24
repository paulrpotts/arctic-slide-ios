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

//enum {
//    POLAR_DATA_LEN_X = 4,
//    POLAR_DATA_LEN_Y = 24,
//    POLAR_DATA_NUM_LEVELS = 6
//};

#define POLAR_DATA_LEN_Y 4               // 4x24 grid
#define POLAR_DATA_LEN_X 24
#define POLAR_DATA_NUM_LEVELS 6          // In the original game

typedef char tile_t;

enum {
    polar_tile_empty = '0',
    polar_tile_tree,
    polar_tile_mountain,
    polar_tile_house,
    polar_tile_ice_block,
    polar_tile_heart,
    polar_tile_bomb,
    polar_tile_last = polar_tile_bomb
};

/*
    Not part of the level data; an extra flag value representing
    edge of board
*/
#define polar_tile_edge 'X'

typedef const char polar_level_array_t[POLAR_DATA_NUM_LEVELS]
                                      [POLAR_DATA_LEN_Y]
                                      [POLAR_DATA_LEN_X];

typedef char polar_board_array_t[POLAR_DATA_LEN_Y]
                                [POLAR_DATA_LEN_X];

extern polar_level_array_t polar_levels;
